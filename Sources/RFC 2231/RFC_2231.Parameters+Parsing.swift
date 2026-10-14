import ASCII
import Byte
import RFC_2045
import RFC_4648

extension RFC_2231.Parameters {

    public init(_ attributes: some Sequence<(name: String, value: String)>) throws(RFC_2231.Parameter.Error) {
        var sections: [RFC_2231.Parameter.Section] = []
        for attribute in attributes {
            sections.append(try RFC_2231.Parameter.Section(attribute: attribute.name, value: attribute.value))
        }
        var values: [String: RFC_2231.Parameter] = [:]
        for name in Set(sections.map(\.name)) {
            values[name] = try Self.parameter(name, sections.filter { $0.name == name })
        }
        self.init(values: values)
    }

    public subscript(name: String) -> RFC_2231.Parameter? {
        values[name.lowercased()]
    }

    private static func parameter(
        _ name: String,
        _ sections: [RFC_2231.Parameter.Section]
    ) throws(RFC_2231.Parameter.Error) -> RFC_2231.Parameter {
        let numbered = sections.filter { $0.number != nil }.sorted { ($0.number ?? 0) < ($1.number ?? 0) }
        let chosen: [RFC_2231.Parameter.Section] =
            !numbered.isEmpty
            ? numbered
            : [sections.first { $0.isExtended } ?? sections[sections.startIndex]]
        for (expected, section) in chosen.enumerated() where section.number != nil {
            guard section.number == expected else {
                throw chosen.filter({ $0.number == section.number }).count > 1
                    ? RFC_2231.Parameter.Error.duplicateSection(name)
                    : RFC_2231.Parameter.Error.missingSection(name)
            }
        }
        let first = chosen[chosen.startIndex]
        let (charset, language, head) =
            try first.isExtended ? Self.initial(first.value, name: name) : (nil, nil, first.value)
        var value = try Self.octets(head, isExtended: first.isExtended, name: name)
        for section in chosen.dropFirst() {
            value += try Self.octets(section.value, isExtended: section.isExtended, name: name)
        }
        return RFC_2231.Parameter(name: name, charset: charset, language: language, value: value)
    }

    private static func initial(
        _ value: String,
        name: String
    ) throws(RFC_2231.Parameter.Error) -> (RFC_2045.Charset?, String?, String) {
        let parts = value.split(separator: "'", maxSplits: 2, omittingEmptySubsequences: false)
        guard parts.count == 3 else {
            throw .missingCharsetDelimiter(name)
        }
        let charset: RFC_2045.Charset?
        do throws(RFC_2045.Charset.Error) {
            charset = try parts[0].isEmpty ? nil : RFC_2045.Charset(parts[0])
        } catch {
            throw .invalidCharset(name)
        }
        return (charset, parts[1].isEmpty ? nil : String(parts[1]), String(parts[2]))
    }

    private static func octets(
        _ value: String,
        isExtended: Bool,
        name: String
    ) throws(RFC_2231.Parameter.Error) -> [Byte] {
        let bytes = value.utf8.map(Byte.init(bitPattern:))
        guard isExtended else { return bytes }
        var octets: [Byte] = []
        octets.reserveCapacity(bytes.count)
        var position = bytes.startIndex
        while position < bytes.endIndex {
            switch bytes[position].bitPattern {
            case 0x25:
                guard position + 2 < bytes.endIndex,
                    let octet = Self.hexadecimal(bytes[position + 1], bytes[position + 2])
                else {
                    throw .invalidPercentEncoding(name)
                }
                octets.append(Byte(bitPattern: octet))
                position += 3
            default:
                octets.append(bytes[position])
                position += 1
            }
        }
        return octets
    }

    private static func hexadecimal(_ high: Byte, _ low: Byte) -> UInt8? {
        do throws(ASCII.Code.Error) {
            return RFC_4648.Base16.decode(high: try ASCII.Code(high), low: try ASCII.Code(low))
        } catch {
            return nil
        }
    }
}

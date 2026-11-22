public import RFC_2045
import RFC_5646

extension IETF.RFC.`2231`.Charset {

    public init(_ charset: IETF.RFC.`2045`.Charset) {
        let parts = charset.rawValue.split(separator: "*", maxSplits: 1)
        self.init(
            name: parts.count == 2 ? IETF.RFC.`2045`.Charset(__unchecked: (), rawValue: String(parts[0])) : charset,
            language: parts.count == 2 ? (try? IETF.RFC.`5646`.LanguageTag(parts[1])) : nil
        )
    }
}

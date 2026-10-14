extension RFC_2231.Parameter {

    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidSectionNumber(String)

        case duplicateSection(String)

        case missingSection(String)

        case missingCharsetDelimiter(String)

        case invalidCharset(String)

        case invalidPercentEncoding(String)
    }
}

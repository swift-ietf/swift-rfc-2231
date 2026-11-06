public import Byte
public import RFC_2045
public import RFC_5646

extension RFC_2231 {

    public struct Parameter: Sendable, Hashable {

        public let name: String

        public let charset: RFC_2045.Charset?

        public let language: RFC_5646.LanguageTag?

        public let value: [Byte]

        public init(
            name: String,
            charset: RFC_2045.Charset?,
            language: RFC_5646.LanguageTag?,
            value: [Byte]
        ) {
            self.name = name
            self.charset = charset
            self.language = language
            self.value = value
        }
    }
}

public import Byte
public import RFC_2045
public import RFC_5646

extension IETF.RFC.`2231` {

    public struct Parameter: Sendable, Hashable {

        public let name: String

        public let charset: IETF.RFC.`2045`.Charset?

        public let language: IETF.RFC.`5646`.LanguageTag?

        public let value: [Byte]

        public init(
            name: String,
            charset: IETF.RFC.`2045`.Charset?,
            language: IETF.RFC.`5646`.LanguageTag?,
            value: [Byte]
        ) {
            self.name = name
            self.charset = charset
            self.language = language
            self.value = value
        }
    }
}

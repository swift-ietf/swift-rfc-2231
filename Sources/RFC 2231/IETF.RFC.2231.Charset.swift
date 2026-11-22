public import RFC_2045
public import RFC_5646

extension IETF.RFC.`2231` {

    public struct Charset: Sendable, Hashable {

        public let name: IETF.RFC.`2045`.Charset

        public let language: IETF.RFC.`5646`.LanguageTag?

        public init(name: IETF.RFC.`2045`.Charset, language: IETF.RFC.`5646`.LanguageTag?) {
            self.name = name
            self.language = language
        }
    }
}

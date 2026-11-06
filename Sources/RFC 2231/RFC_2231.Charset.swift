public import RFC_2045
public import RFC_5646

extension RFC_2231 {

    public struct Charset: Sendable, Hashable {

        public let name: RFC_2045.Charset

        public let language: RFC_5646.LanguageTag?

        public init(name: RFC_2045.Charset, language: RFC_5646.LanguageTag?) {
            self.name = name
            self.language = language
        }
    }
}

public import RFC_2045

extension RFC_2231 {

    public struct Charset: Sendable, Hashable {

        public let name: RFC_2045.Charset

        public let language: String?

        public init(name: RFC_2045.Charset, language: String?) {
            self.name = name
            self.language = language
        }
    }
}

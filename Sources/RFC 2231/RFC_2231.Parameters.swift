extension RFC_2231 {

    public struct Parameters: Sendable, Hashable {

        public let values: [String: RFC_2231.Parameter]

        public init(values: [String: RFC_2231.Parameter]) {
            self.values = values
        }
    }
}

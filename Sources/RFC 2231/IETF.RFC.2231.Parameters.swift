extension IETF.RFC.`2231` {

    public struct Parameters: Sendable, Hashable {

        public let values: [String: IETF.RFC.`2231`.Parameter]

        public init(values: [String: IETF.RFC.`2231`.Parameter]) {
            self.values = values
        }
    }
}

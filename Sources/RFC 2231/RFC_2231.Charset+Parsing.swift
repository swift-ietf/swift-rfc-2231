public import RFC_2045

extension RFC_2231.Charset {

    public init(_ charset: RFC_2045.Charset) {
        let parts = charset.rawValue.split(separator: "*", maxSplits: 1)
        self.init(
            name: parts.count == 2 ? RFC_2045.Charset(__unchecked: (), rawValue: String(parts[0])) : charset,
            language: parts.count == 2 ? String(parts[1]) : nil
        )
    }
}

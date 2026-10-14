extension RFC_2231.Parameter.Section {

    init(attribute: String, value: String) throws(RFC_2231.Parameter.Error) {
        let lowered = attribute.lowercased()
        let isExtended = lowered.hasSuffix("*")
        let stem = isExtended ? String(lowered.dropLast()) : lowered
        let parts = stem.split(separator: "*", maxSplits: 1, omittingEmptySubsequences: false)
        switch parts.count {
        case 2:
            let digits = parts[1]
            guard !digits.isEmpty, digits.allSatisfy(\.isASCIIDigitCharacter),
                digits == "0" || !digits.hasPrefix("0"),
                let number = Int(digits)
            else {
                throw .invalidSectionNumber(attribute)
            }
            self.init(name: String(parts[0]), number: number, isExtended: isExtended, value: value)
        default:
            self.init(name: stem, number: nil, isExtended: isExtended, value: value)
        }
    }
}

extension Character {

    fileprivate var isASCIIDigitCharacter: Bool {
        ("0"..."9").contains(self)
    }
}

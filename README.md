# swift-rfc-2231

Use this package when you read MIME header parameters, such as a `filename` in Content-Disposition, that may be split into numbered sections or carry a character set and language. Pass the raw name and value pairs to `RFC_2231.Parameters` and look parameters up by name. Values come back as octets with their declared charset, and turning them into text is left to you. To split the language from an encoded word's charset, as in `US-ASCII*EN`, use `RFC_2231.Charset`. For the encoded words themselves, use swift-rfc-2047.

## Laws

- Parameter names are case-insensitive. Names are stored lowercased, and lookup lowercases the name it is given.
- Numbered sections such as `URL*0` and `URL*1` are joined in number order, whatever order they arrive in. The numbers must run from 0 without a gap, or parsing fails with `RFC_2231.Parameter.Error.missingSection(_:)`. A number given twice fails with `RFC_2231.Parameter.Error.duplicateSection(_:)`, and a number with a leading zero fails with `RFC_2231.Parameter.Error.invalidSectionNumber(_:)`.
- When a parameter has numbered sections, they are used and any unnumbered form is ignored. Otherwise the extended form `name*` is used over the plain form `name`.
- The charset and language come only from the first section, which must hold two `'` delimiters, as in `us-ascii'en-us'...`. A blank charset or language is nil.
- Only extended sections, those whose name ends in `*`, are percent-decoded. A `%` must be followed by two hexadecimal digits. Decoded octets outside ASCII are kept as they are. Plain sections are taken as their UTF-8 bytes, and extended and plain sections may be mixed in one value.
- Values are used exactly as given. Quotes around a plain value are not removed.

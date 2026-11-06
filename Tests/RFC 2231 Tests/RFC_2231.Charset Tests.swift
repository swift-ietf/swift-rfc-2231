import RFC_2045
import RFC_2231
import RFC_5646
import Testing

enum `RFC_2231.Charset Tests` {}

extension `RFC_2231.Charset Tests` {

    @Suite
    struct Test {

        @Suite
        struct Unit {}
    }
}

extension `RFC_2231.Charset Tests`.Test.Unit {

    @Test
    func `a language suffix is split from the charset`() throws {
        let charset = RFC_2231.Charset(try RFC_2045.Charset("US-ASCII*EN"))

        #expect(charset.name == "US-ASCII")
        #expect(charset.language?.value == "en")
    }

    @Test
    func `a charset without a language stays whole`() throws {
        let charset = RFC_2231.Charset(try RFC_2045.Charset("UTF-8"))

        #expect(charset.name == "UTF-8")
        #expect(charset.language == nil)
    }
}

import RFC_2045
import RFC_2231
import RFC_5646
import Testing

enum `IETF.RFC.2231.Charset Tests` {}

extension `IETF.RFC.2231.Charset Tests` {

    @Suite
    struct Test {

        @Suite
        struct Unit {}
    }
}

extension `IETF.RFC.2231.Charset Tests`.Test.Unit {

    @Test
    func `a language suffix is split from the charset`() throws {
        let charset = IETF.RFC.`2231`.Charset(try IETF.RFC.`2045`.Charset("US-ASCII*EN"))

        #expect(charset.name == "US-ASCII")
        #expect(charset.language?.value == "en")
    }

    @Test
    func `a charset without a language stays whole`() throws {
        let charset = IETF.RFC.`2231`.Charset(try IETF.RFC.`2045`.Charset("UTF-8"))

        #expect(charset.name == "UTF-8")
        #expect(charset.language == nil)
    }
}

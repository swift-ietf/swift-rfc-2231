import Byte
import RFC_2045
import RFC_2231
import Testing

extension RFC_2231.Parameters {

    @Suite
    struct Test {

        @Suite
        struct Unit {}

        @Suite
        struct `Edge Case` {}

        static func text(_ parameter: RFC_2231.Parameter?) -> String? {
            parameter.map { String(decoding: $0.value.map(\.bitPattern), as: UTF8.self) }
        }
    }
}

extension RFC_2231.Parameters.Test.Unit {

    @Test
    func `continuations are joined in order`() throws {
        let parameters = try RFC_2231.Parameters([
            (name: "URL*1", value: "cs.utk.edu/pub/moore/bulk-mailer/bulk-mailer.tar"),
            (name: "URL*0", value: "ftp://"),
        ])

        #expect(
            RFC_2231.Parameters.Test.text(parameters["url"])
                == "ftp://cs.utk.edu/pub/moore/bulk-mailer/bulk-mailer.tar"
        )
    }

    @Test
    func `an extended value carries its charset and language`() throws {
        let parameters = try RFC_2231.Parameters([
            (name: "title*", value: "us-ascii'en-us'This%20is%20%2A%2A%2Afun%2A%2A%2A")
        ])

        #expect(RFC_2231.Parameters.Test.text(parameters["title"]) == "This is ***fun***")
        #expect(parameters["title"]?.charset == "US-ASCII")
        #expect(parameters["title"]?.language == "en-us")
    }

    @Test
    func `extended and plain continuations combine`() throws {
        let parameters = try RFC_2231.Parameters([
            (name: "title*0*", value: "us-ascii'en'This%20is%20even%20more%20"),
            (name: "title*1*", value: "%2A%2A%2Afun%2A%2A%2A%20"),
            (name: "title*2", value: "isn't it!"),
        ])

        #expect(RFC_2231.Parameters.Test.text(parameters["title"]) == "This is even more ***fun*** isn't it!")
        #expect(parameters["title"]?.language == "en")
    }

    @Test
    func `a percent encoded octet outside ASCII is kept as an octet`() throws {
        let parameters = try RFC_2231.Parameters([(name: "filename*", value: "iso-8859-1''caf%E9.pdf")])

        #expect(parameters["filename"]?.value == [Byte](utf8: "caf") + [Byte(bitPattern: 0xE9)] + [Byte](utf8: ".pdf"))
        #expect(parameters["filename"]?.charset == "ISO-8859-1")
        #expect(parameters["filename"]?.language == nil)
    }

    @Test
    func `a plain parameter passes through`() throws {
        let parameters = try RFC_2231.Parameters([(name: "Filename", value: "a.pdf")])

        #expect(RFC_2231.Parameters.Test.text(parameters["filename"]) == "a.pdf")
        #expect(parameters["filename"]?.charset == nil)
    }

    @Test
    func `the extended form wins over the plain form`() throws {
        let parameters = try RFC_2231.Parameters([
            (name: "filename", value: "fallback.pdf"),
            (name: "filename*", value: "utf-8''real.pdf"),
        ])

        #expect(RFC_2231.Parameters.Test.text(parameters["filename"]) == "real.pdf")
    }
}

extension RFC_2231.Parameters.Test.`Edge Case` {

    @Test
    func `a missing section is refused`() {
        #expect(throws: RFC_2231.Parameter.Error.missingSection("x")) {
            try RFC_2231.Parameters([(name: "x*0", value: "a"), (name: "x*2", value: "c")])
        }
    }

    @Test
    func `a duplicate section is refused`() {
        #expect(throws: RFC_2231.Parameter.Error.duplicateSection("x")) {
            try RFC_2231.Parameters([(name: "x*0", value: "a"), (name: "x*0", value: "b")])
        }
    }

    @Test
    func `a section number with a leading zero is refused`() {
        #expect(throws: RFC_2231.Parameter.Error.invalidSectionNumber("x*01")) {
            try RFC_2231.Parameters([(name: "x*01", value: "a")])
        }
    }

    @Test
    func `an extended value without its quotes is refused`() {
        #expect(throws: RFC_2231.Parameter.Error.missingCharsetDelimiter("x")) {
            try RFC_2231.Parameters([(name: "x*", value: "plain")])
        }
    }

    @Test
    func `a broken percent escape is refused`() {
        #expect(throws: RFC_2231.Parameter.Error.invalidPercentEncoding("x")) {
            try RFC_2231.Parameters([(name: "x*", value: "''a%ZZ")])
        }
        #expect(throws: RFC_2231.Parameter.Error.invalidPercentEncoding("x")) {
            try RFC_2231.Parameters([(name: "x*", value: "''a%4")])
        }
    }

    @Test
    func `a blank charset and language are absent`() throws {
        let parameters = try RFC_2231.Parameters([(name: "x*", value: "''abc")])

        #expect(parameters["x"]?.charset == nil)
        #expect(parameters["x"]?.language == nil)
    }
}

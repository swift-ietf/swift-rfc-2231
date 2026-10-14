# swift-rfc-2231

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Foundation-free Swift implementation of RFC 2231: MIME parameter value and encoded word extensions.

The package joins parameter value continuations (`name*0`, `name*1`, …), decodes extended values with their character set and language (`name*=charset'language'%XX`), and splits the language suffix from an encoded word's charset (`charset*language`). Values are octets; turning them into text in a charset is outside this specification package.

```swift
import RFC_2231

let parameters = try RFC_2231.Parameters([
    (name: "title*0*", value: "us-ascii'en'This%20is%20"),
    (name: "title*1", value: "fun"),
])
parameters["title"]?.value     // the octets of "This is fun"
parameters["title"]?.language  // "en"
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).

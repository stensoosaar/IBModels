# IBModels

A native Swift library representing Interactive Brokers request and response data models. This library does **not** include the network connection or socket transport — you are free to use your preferred technology (e.g. `Network`, `SwiftNIO`, etc.) to handle reading and writing to the TWS API socket.

IBModels supports TWS API (using gateway or traders workstation), Webapi is currently not supported.

---

## Highlights

- All requests and responses are represented as **value types** (`structs`)
- Requests are `Encodable`, responses are `Decodable`, not functions or callbacks
- Swift-native types and naming conventions used for readability and safety
- Consistent with IB protocol yet idiomatic for Swift developers
- No required dependencies or runtime glue — purely typed models and encoding/decoding

---

## Adding Dependancy
To use the `IBModels` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/stensoosaar/ibmodels", from: "10.33.0"),
```

Include `"TWS"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "TWS", package: "ibmodels"),
]),
```

---

## Creating a Request

All requests conform to `Encodable` and can be encoded using the included `IBEncoder`.

```swift
var aapl = Contract()
aapl.type = .stock
aapl.symbol = "AAPL"
aapl.currency = "USD"
aapl.exchange = "SMART"

let request = MarketDataRequest(id: 1, contract: aapl)
let encoder = IBEncoder(serverVersion)

let data = try encoder.encode(request)

// Write 4-byte length header + data to the socket or use encoders' dataWithLength parameter
```

---

## Reading from the Socket

1. Read the first 4 bytes (message length)
2. Read the message payload
3. Pass the message payload (not the length) to `IBDecoder`

```swift
let decoder = IBDecoder(serverVersion: client.serverVersion)
let response = try decoder.decode(Response.self, from: data)
```

Decoded `Response.result` contains response type , optional identifier matching originating request identifier and payload as`Result<Response, ErrorMessage>`
If the request has id, also responses have corresponding id. Rest of the messages need to be match by type (eg managedAccount request matches managedAccount response) or types 
(AccountUpdate request matches accountValue, positionUpdatem accountUpdateTime responses) 

---

## Notable Differences

While most of the requests and responses loosely follow TWS API models, there are few differences with market data responses.
- Price updates are moved from ´TickPrice´ to ´TickQuote´ message to reduce message count. 
- Original ´TickString´ and ´TickGeneric´ messages  

---

## Summary

- Request/response model using value types
- Custom encoding/decoding with full control over versioning
- Easy to integrate into reactive or concurrent pipelines
- Explicit request–response linking for context restoration
- Decoupled from networking, you can use technology you like.

# IBModels
![API Version](https://img.shields.io/badge/API_Version-10.33.0-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-blue.svg)
[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-blue.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/stensoosaar/IBKit#license) 

A native Swift library representing Interactive Brokers request and response data models. 

This library does **not include** the network connection or socket transport — you're free to use your preferred technologies such as `Network`, `SwiftNIO`, or others to manage communication with the TWS API socket.

Furthermore, by separating the model layer from the client implementation, developers retain full flexibility in choosing not only the transport mechanism but also how data is delivered and processed — whether using `Combine`, `Swift Concurrency`, or any other reactive architecture. 

**This project is not affiliated with or endorsed by Interactive Brokers.**


## Highlights
- All requests and responses are represented as **value types** (`structs`)
- Requests are `Encodable`, responses are `Decodable`, not functions or callbacks
- Swift-native types and naming conventions used for readability and safety.
- Consistent with IB protocol yet idiomatic for Swift developers
- No required dependencies — purely typed models and encoding/decoding


## Adding Dependency
To use the `IBModels` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/stensoosaar/ibmodels", from: "10.33.0")
}

```

Include `"TWS"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "TWS", package: "ibmodels"),
]),
```

## Important: TWS/Gateway Configuration
Please ensure that your **Gateway** or **Workstation** configuration is set to use the **UTC time zone**.
> You can configure the time zone in the **TWS / Gateway settings** under: Gloabl Configuartion> API > Settings > Send instrument specific attributes for dual-mode API client in: ´format´.

This is important because:
- IB uses multiple, locale-dependent date formats across different messages
- This library decodes dates using native `Date` types instead of raw strings
- Without UTC, decoding may fail or produce incorrect results due to ambiguous or inconsistent formats



## Creating a Request
All requests conform to `Encodable` and can be encoded using the included `IBEncoder`. 
> **Note:** Many request and response message structures depend on the current server version. Therefore, the server version is usually required during both encoding and decoding to ensure proper message formatting and interpretation.

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
Some requests initiate streaming data (e.g., market data or account updates). These requests conform to the AnyCancellableRequest protocol and are automatically paired with their corresponding cancellation request. You can cancel a stream by sending:
- request.cancel to get the matching cancellation message
or 
- using a dedicated cancellation request, if needed.
  
This makes it easy to manage the full request lifecycle — from starting a stream to explicitly stopping it.


## Reading from the Socket
1. Read the first 4 bytes (message length)
2. Read the message payload
3. Create Decoder with current session server version
4. Pass the message payload (without the length) to `IBDecoder`

```swift
let decoder = IBDecoder(serverVersion: client.serverVersion)
let response = try decoder.decode(Response.self, from: data)
```

Decoded `Response.result` contains response type , optional identifier matching originating request identifier and payload as `Result<Response, ErrorMessage>`

## Pairing Requests and Responses
For the sake of bandwidth efficiency and speed, many incoming messages from IB are stripped down to the bare minimum, lacking context about the original request. It’s up to the developer to pair responses with their originating requests to interpret the messages correctly.
If the request has id, also responses have corresponding id. Rest of the messages need to be match by type (eg managedAccount request matches managedAccount response) or types 
(AccountUpdate request matches accountValue, positionUpdate accountUpdateTime responses)

Some ideas to handle this:
- **Request Buffering:** Keep a buffer of active requests in memory and match them to incoming responses by ID or message type. Once matched, you can deliver a combined wrapper of both request and response.
- **Publisher-based Routing:** Use a Publisher for each outgoing request and compare incoming messages by type and ID. This approach lets you route messages directly to the appropriate pipeline or handler.
This pairing is essential for reconstructing context around minimal IB responses, especially for complex workflows like market data, account updates, or order status tracking.


```swift
func dataTaskPublisher<T: IdentifiableRequest>(for request: T) -> AnyPublisher<IBEvent, Error> {
    return yourMessagePipeline
        .filter {
            guard let responseID = $0.requestId else { return false }
            return request.id == responseID
        }
        .tryMap { response in
            switch response.result {
            case .success(let object):
                return object
            case .failure(let error):
            	throw error
            }
        }
        .handleEvents(
        	receiveSubscription: { _ in
            	self.sendRequest(request)
            },
            receiveCancel: {
                if let cancellable = request as? AnyCancellableRequest {
                    self.sendRequest(cancellable.cancel)
                }
            }
        )
        .eraseToAnyPublisher()
}

```


## Notable Differences
While most of the requests and responses loosely follow TWS API models, there are few differences with market data responses.
- Quote (price,size) related updates are moved from the TickPrice message to the TickQuote message to reduce message count. However, price statistics (e.g., high, low, close) are still returned via the TickPrice message. 
- Original ´TickString´ and ´TickGeneric´ messages delivered opaque payloads that required additional parsing to extract context-specific data such as dividends, real-time volume and sales, or shortable status. In this model, these have been replaced with dedicated, structured message types to provide better clarity.


## Update Frequency
I'll try to keep the library up to date with the latest IB protocol changes and Swift improvements — usually with a refresh and new features about once a year.


## Summary
- Request/response model using value types
- Custom encoding/decoding with full control over versioning
- Easy to integrate into reactive or concurrent pipelines
- Explicit request–response linking for context restoration
- Fully decoupled from networking — you're free to use any transport or pipeline technology you prefer.

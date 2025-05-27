/*
 MIT License

 Copyright (c) 2016-2025 Sten Soosaar

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation



/**
 Request to important platform or exchange related messages sent by IB
 
 From time to time IB sends platform or exchange related news bulletins,
 like trading halted or resumed in particular exchange.
 - returns: `NewsBulletin` stream
 - note: Use `NewsBulletinsCancel` to stop receiving updates.
 */
public struct NewsBulletinsRequest: AnyCancellableRequest{

	/// The type of the request, used to identify it in the IB protocol.
	public let type: RequestType = .newsBulletins

	/// Message version, used for decodin
	private let version: Int = 1

	/// Capacity of messages
	public let includePast: Bool
	
	/**
	 Creates new request for receiving new bulletins
	 - parameter includePast: if true, requests all current day bulletings. otherwise only the new ones.
	 */
	public init(includePast: Bool = true) {
		self.includePast = includePast
	}

	/// The corresponding cancellation request for this subscription.
	public var cancel: AnyRequest {
		return NewsBulletinsCancel()
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(includePast)
	}
	
}

/**
 Cancellation request for NewsBulletinsRequest
 */
public struct NewsBulletinsCancel: AnyRequest{
	
	/// The type of the request.
	public let type: RequestType = .newsBulletinsCancel
	
	private let version: Int = 1

	/// Initializes a cancellation request to stop News Bulletins stream.
	public init(){}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		
	}
}



/**
 IB new bulletin message
 */
public struct NewsBulletin:  IBEvent, IBDecodable {
		
	/// the bulletin's identifier
	public let id: Int
	
	public enum MessageType: Int, Decodable, Sendable {
		case regular = 1
		case tradingHalted = 2
		case tradingResumed = 3
	}
	
	/// message type
	public let messageType: MessageType
	
	/// the message text
	public let message: String
	
	/// the exchange where the message comes from.
	public let source: String

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
		messageType = try container.decode(MessageType.self)
		message = try container.decode(String.self)
		source = try container.decode(String.self)
	}
}

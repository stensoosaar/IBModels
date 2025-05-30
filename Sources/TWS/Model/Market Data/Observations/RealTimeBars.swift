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
 Request to query real time bar updates.
 */
public struct RealTimeBarsRequest: AnyCancellableRequest, IdentifiableRequest{
	
	public let type: RequestType = .realTimeBars
	
	private let version:Int = 3

	private let minimumServerVersion: ServerVersion = .realTimeBars

	public let id: Int
	
	public let contract: Contract
	
	public let barSize: BarSize = .secs5
	
	public let source: BarSource
	
	public let extendedTrading: Bool
	
	public let options: [String:String]?
	
	/**
	 Creates new request to stream real time bars
	 - parameter id: unique reqiest id
	 - parameter contract: contract
	 - parameter source: what data to observe (eg. trades)
	 - parameter extendedTrading: include data outside the regular trading session
	 - note: only 5 second bars are delivered
	 */
	public init(id: Int, contract:Contract, source: BarSource, extendedTrading: Bool) {
		self.id = id
		self.contract = contract
		self.source = source
		self.extendedTrading = extendedTrading
		self.options = nil
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return RealTimeBarsCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
			
		try container.encode(contract)
						
		try container.encode(5)
		try container.encode(source)
		try container.encode(extendedTrading.reverseValue())
			
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
			
		
	}
}

/**
 Cancellation of an outstanding real time bar request
 */
public struct RealTimeBarsCancel: IdentifiableRequest{
	
	public let type: RequestType = .realTimeBarsCancel

	private let version:Int = 1
	
	private let minimumServerVersion: ServerVersion = .realTimeBars

	public let id: Int

	public init (id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
}



/**
 An event containing bar containind data collected in last 5 seconds
*/
public struct RealtimeBar: IBEvent, IBDecodable, Identifiable {
		
	/// id of originating request
	public let id: Int
	
	/// bar with 5 second sample size
	public let bar: Bar
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		let timestamp = try container.decode(Double.self)
		let date = Date(timeIntervalSince1970: timestamp)
		let open = try container.decode(Double.self)
		let high = try container.decode(Double.self)
		let low = try container.decode(Double.self)
		let close = try container.decode(Double.self)
		let volume = try container.decodeOptional(Double.self)
		let vwap = try container.decodeOptional(Double.self)
		let count = try container.decodeOptional(Int.self)
		
		self.bar = Bar(
			date: date,
			open: open,
			high: high,
			low: low,
			close: close,
			volume: volume,
			vwap: vwap,
			count: count
		)
		
	}
}

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
 Request to query first available timeseries data for respective contract / source.
 It does not return historical data itself, only the earliest timestamp available.
 
 - note: If the request is no longer needed **before** the response arrives, it shoud be cancelled from client side.
 Otherwise, it may continue to consume a slot in the limited concurrent request buffer until the server responds.
 
 - important: max 50 concurrent requests allowed
 
 */
public struct HeadTimestampRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .headTimestamp
	
	private let minimumServerVersion: ServerVersion = .reqHeadTimestamp

	public let id: Int
	
	public let contract: Contract
		
	public let source: BarSource
	
	public let extendedTrading: Bool

	public let formatDate: Int = 1
	
	/**
	 Creates the new request to query first available timeseries data for respective contract / source
	 
	 - returns: `HeadTimestamp` message
	 - parameter id: unique request id
	 - parameter contract: contract
	 - parameter source: what data shall be used to build the bar
	 - parameter extendedTrading: include also pre- and post market data
	 */
	public init (id: Int, contract: Contract, source:BarSource, extendedTrading: Bool) {
		self.id = id
		self.contract = contract
		self.source = source
		self.extendedTrading = extendedTrading
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return HeadTimestampCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(contract.includeExpired)
		try container.encode(extendedTrading.reverseValue())
		try container.encode(source)
		try container.encode(formatDate)
	}
}

/**
 Request to cancel ongoing query first available timeseries data for respective contract / source
 */
public struct HeadTimestampCancel: IdentifiableRequest {
	
	public let type: RequestType = .realTimeBarsCancel
	private let minimumServerVersion: ServerVersion = .cancelHeadtimestamp
	
	/// orginating request id
	public let id: Int

	/// creates new cancellation of the outstanding request
	public init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
}



/**
 Delivers earliest available date for requested time contract / timeseries
 */
public struct HeadTimestamp: IBEvent, IBDecodable, Identifiable{

	/// orginating request id
	public let id: Int

	/// beginning timestamp of requested time series
	public let date: Date
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
		
	}

}

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
 Requests price / size data without dates
 */
public struct HistogramDataRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .histogramData
	
	private let minimumServerVersion: ServerVersion = .reqHistogram
	
	/// request id
	public let id: Int
	
	/// contract
	public let contract: Contract
	
	///
	public let extendedTrading: Bool
	
	
	public let interval: DateInterval

	public init(id: Int, contract: Contract, interval: DateInterval, extendedTrading: Bool){
		self.id = id
		self.contract = contract
		self.extendedTrading = extendedTrading
		self.interval = interval
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return HistogramDataCancel(id: id)
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(contract.includeExpired)
		try container.encode(extendedTrading.reverseValue())
		try container.encode(interval.twsDescriptionLong)
	}
}

								  
public struct HistogramDataCancel: IdentifiableRequest {
	
	public let type: RequestType = .histogramData
	
	private let minimumServerVersion: ServerVersion = .reqHistogram
	
	public let id: Int

	public init(id: Int){
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
}



/**
 Returns histogram data for a contract
 */
public struct HistogramDataUpdate: IBEvent, IBDecodable, Identifiable {
		
	/// id matching originating request id
	public let id: Int
	
	/// events
	public let series: [Quote]
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		var buffer: [Quote] = []
		for _ in 0..<count {
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)
			buffer.append(Quote(price: price, size: size))
		}
		series = buffer
	}
	
}

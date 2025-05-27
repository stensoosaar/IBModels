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



public struct TickDataRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .tickByTickData
	
	private let minimumServerVersion: ServerVersion = .tickByTick

	public let id: Int
	
	public let contract: Contract
	
	public enum TickType: String, Codable, Sendable {
		case last = "Last"
		case allLast = "AllLast"
		case bidAsk = "BidAsk"
		case midPoint = "MidPoint"
	}

	
	public let tickType: TickType

	public let numberOfTicks: Int
	
	public let ignoreSize: Bool
	
	public init(
		id: Int,
		contract: Contract,
		tickType: TickType,
		numberOfTicks: Int,
		ignoreSize: Bool
	){
		self.id = id
		self.contract = contract
		self.tickType = tickType
		self.numberOfTicks = numberOfTicks
		self.ignoreSize = ignoreSize
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return TickDataCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(tickType)
		
		if encoder.serverVersion >= .tickByTickIgnoreSize {
			try container.encode(numberOfTicks)
			try container.encode(ignoreSize)
		}
		
	}
}

								  
public struct TickDataCancel: IdentifiableRequest {
	
	public let type: RequestType = .tickByTickDataCancel
	
	public let id: Int
		
	private let minimumServerVersion: ServerVersion = .tickByTick
	
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
 returns tick-by-tick data for tickType = "Last" or "AllLast"
 */
public struct TickByTickResponse: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let tickType: TickDataRequest.TickType

	public let time: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickDataRequest.TickType.self)
		self.time = try container.decode(Int.self)
		
		switch tickType {
		case .last:
			break
			
		case .allLast:
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)
			let mask = try container.decode(Int.self)
			let pastLimit = mask & 1 != 0
			let unsupported = mask & 2 != 0
			let exchange = try container.decode(String.self)
			let condition = try container.decode(String.self)
		
		case .bidAsk:
			let bidPrice = try container.decode(Double.self)
			let askPrice = try container.decode(Double.self)
			let bidSize = try container.decode(Double.self)
			let askSize = try container.decode(Double.self)
			let mask = try container.decode(Int.self)
			let bidPastLow = mask & 1 != 0
			let askPastHigh = mask & 2 != 0

		case .midPoint:
			let mid = try container.decode(Double.self)
		}
		
	}
	
}


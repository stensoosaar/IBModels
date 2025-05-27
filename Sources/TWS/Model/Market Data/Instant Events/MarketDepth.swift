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
 Represents an Contract's order book
 */

public struct MarketDepthRequest: AnyCancellableRequest, Identifiable {
	public let type: RequestType = .marketDepth
	private let version:Int = 5
	private let minimumServeVersion:Int = 6
	public let id: Int
	public let contract: Contract
	public let numRows: Int
	public let isSmartDepth: Bool
	public let options: [String:String]?
	
	/**
	 Creates new request to query orderbook aka market depth updates. Odd lot orders are not included.

	 - parameter id: unique request id
	 - parameter contract: contract
	 - parameter rows: maximum row count to show.
	 - parameter isSmartDepth: no idea
	 
	 - important: the amount of active depth requests is related to the amount of market data lines, with a minimum of three and maximum of 60
	 */
	public init (id: Int, contract: Contract, rows: Int, isSmartDepth: Bool) {
		self.id = id
		self.contract = contract
		self.numRows = rows
		self.isSmartDepth = isSmartDepth
		self.options = nil
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		MarketDepthCancel(id: id, isSmartDepth: isSmartDepth)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(contract)
		if encoder.serverVersion.rawValue >= 19 {
			try container.encode(numRows)
		}
		if encoder.serverVersion >= .smartDepth {
			try container.encode(isSmartDepth)
		}
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
		
	}
}

/**
 Cancellation request of outstanding MarketDepth request
 */
public struct MarketDepthCancel: AnyRequest, Identifiable {
	
	public let type: RequestType = .marketDepthCancel

	private let version:Int = 1

	private let minimumServerVersion: Int = 6
	
	public let id: Int
	
	public let isSmartDepth: Bool

	/**
	 Creates new request to cancel orderbook aka market depth updates
	 - parameter id: unique request id
	 - parameter isSmartDepth: no idea

	 */
	public init (id: Int, isSmartDepth: Bool) {
		self.id = id
		self.isSmartDepth = isSmartDepth
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode( id)
			
		if encoder.serverVersion >= .smartDepth {
			try container.encode( isSmartDepth)
		}

	}
}

public enum OperationType: Int, Sendable, Decodable{
	/// insert this new order into the row identified by 'position'
	case insert = 0
	
	///update the existing order in the row identified by 'position')
	case update = 1
	
	///delete the existing order at the row identified by 'position')
	case delete = 2
}



/**
 Represents an Contract's order book.
 */
public struct MarketDepthUpdate: AnyMarketDepth, Identifiable{
	
	/// id of originating request
	public let id: Int

	/// the order book's row being updated
	public let row: Int

	/// how to refresh the row
	public let operation: OperationType

	/// quote side
	public let side: QuoteSide

	/// quoted price and size
	public let quote: Quote

	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.row = try container.decode(Int.self)
		self.operation = try container.decode(OperationType.self)
		self.side = try container.decode(QuoteSide.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		self.quote = Quote(price: price, size: size)
	}
	
}


/**
 Represents an Contract's order book with market maket information
 */
public struct MarketDepthUpdateL2: AnyMarketDepth, Identifiable{
	
	/// the request's identifier
	public let id: Int

	/// the order book's row being updated
	public let row: Int

	/// how to refresh the row
	public let operation: OperationType

	/// quote size
	public let side: QuoteSide

	/// price and size of a bid/ask
	public let quote: Quote

	/// Market maker or exchange holding the order
	public let marketMaker: String

	///is SMART Depth request
	public let isSmartDepth: Bool

	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.row = try container.decode(Int.self)
		self.marketMaker = try container.decode(String.self)
		self.operation = try container.decode(OperationType.self)
		self.side = try container.decode(QuoteSide.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		self.quote = Quote(price: price, size: size)
		isSmartDepth = decoder.serverVersion >= .smartDepth ? try container.decode(Bool.self) : false
	}
	
}





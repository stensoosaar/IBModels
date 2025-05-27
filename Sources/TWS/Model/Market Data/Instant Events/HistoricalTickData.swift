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



public struct HistoricalTickDataRequest: IdentifiableRequest{
	
	public let type: RequestType = .historicalTicks
	
	private let minimumServerVersion: ServerVersion = .historicalTicks

	public let id: Int
	
	public let contract: Contract
	
	public let interval: DateInterval
		
	public let numberOfTicks: Int
	
	public let source: BarSource
	
	public let extendedTrading: Bool
	
	public let ignoreSize: Bool
	
	public let options: [String: String]?
	
	public init(
		id: Int,
		contract: Contract,
		interval: DateInterval,
		numberOfTicks: Int,
		source: BarSource,
		extendedTrading: Bool,
		ignoreSize: Bool
	) {
		self.id = id
		self.contract = contract
		self.interval = interval
		self.numberOfTicks = numberOfTicks
		self.source = source
		self.extendedTrading = extendedTrading
		self.ignoreSize = ignoreSize
		self.options = nil
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(contract.includeExpired)
		try container.encode(interval.start)
		try container.encode(interval.end)
		try container.encode(numberOfTicks)
		try container.encode(source)
		try container.encode(extendedTrading.reverseValue())
		try container.encode(ignoreSize)
		try container.encodeOptional(options)
	}
}



public enum TickAttributes: Decodable, Sendable{
	
	///Used with tickPrice callback from reqMktData. Specifies whether the price tick is available for automatic execution (1) or not (0).
	case canAutoExecute
	
	/// Used with tickPrice to indicate if the bid price is lower than the day’s lowest value or the ask price is higher than the highest ask.
	case pastLimit
	
	///Indicates whether the bid/ask price tick is from pre-open session.
	case preOpen
	
	///Used with tick-by-tick data to indicate if a trade is classified as ‘unreportable’ (odd lots)
	case bidPastLow
	
	///Used with real time tick-by-tick. Indicates if bid is lower than day’s lowest low.
	case askPastHigh
	
	///Used with real time tick-by-tick. Indicates if ask is higher than day’s highest ask.
	case unreported
	
}



public enum QuoteSide: Int, Decodable, Sendable{
	case ask = 0
	case bid = 1
	case trade = 2
}


public struct Quote: Sendable{
	public var price: Double
	public var size: Double
}


public protocol HistoricalTickEvent: Sendable, IBDecodable{}

/**
 Used when requesting historical tick data with whatToShow = MIDPOINT.
 */
public struct HistoricalTick: HistoricalTickEvent{

	/// Event date
	public var date: Date

	/// mid price
	public var midpoint: Quote
	
	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		date = try container.decode(Date.self)
		_ = try container.decode(Int.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		self.midpoint = Quote(price: price, size: size)
	}
}

/**
 Used when requesting historical tick data with whatToShow = BID_ASK.
 */
public struct HistoricalTickBidAsk: HistoricalTickEvent{
	
	/// Event date
	public var date: Date
	
	///The bid price & size of the historical tick.
	public var bid: Quote
	
	///The ask price & size of the historical tick.
	public var ask: Quote
	
	///The conditions of the historical tick. Refer to Trade Conditions page for more details.
	public var attributes: [TickAttributes]

	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.date = try container.decode(Date.self)

		var attr: [TickAttributes] = []
		let mask = try container.decode(Int.self)
		if mask & 1 != 0 { attr.append(.askPastHigh)}
		if mask & 2 != 0 { attr.append(.bidPastLow)}
		
		let bidPrice = try container.decode(Double.self)
		let askPrice = try container.decode(Double.self)
		let bidSize = try container.decode(Double.self)
		let askSize = try container.decode(Double.self)
		
		self.bid = Quote(price: bidPrice, size: bidSize)
		self.ask = Quote(price: askPrice, size: askSize)
		self.attributes = attr
	}

}

/**
 Used when requesting historical tick data with whatToShow = TRADES.
 */
public struct HistoricalTickLast: HistoricalTickEvent{
	
	/// Event date
	public var date: Date
	
	///The last price & size of the historical tick.
	public var trade: Quote
	
	///The source exchange of the historical tick.
	public var exchange: String
	
	///The conditions of the historical tick. Refer to Trade Conditions page for more details.
	public var attributes: [TickAttributes]
	
	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.date = try container.decode(Date.self)
		
		var attr: [TickAttributes] = []
		let mask = try container.decode(Int.self)
		if mask & 1 != 0 {attr.append(.pastLimit)}
		if mask & 2 != 0 {attr.append(.unreported)}

		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		self.trade = Quote(price: price, size: size)
		self.exchange = try container.decode(String.self)
		self.attributes = attr
	}

}



struct HistoricalTickData<T:HistoricalTickEvent>: IBEvent, IBDecodable, Identifiable {
	
	public let id: Int
	public let series: [T]
	public let done: Bool

	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		
		var result: [T] = []
		for _ in 0..<count {
			let tick = try T(from: decoder)
			result.append(tick)
		}
		
		self.series = result
		self.done = try container.decode(Bool.self)
	}
	
}





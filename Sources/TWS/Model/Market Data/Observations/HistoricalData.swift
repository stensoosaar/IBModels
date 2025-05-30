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
 Request to query historical time series
 */
public struct HistoricalDataRequest: AnyCancellableRequest, IdentifiableRequest{
	
	public let type: RequestType = .historicalData
	
	private let version:Int = 6

	private let minimumServerVersion: ServerVersion? = nil
	
	public let id: Int
	
	public let contract: Contract
	
	public let interval: DateInterval
	
	public let size: BarSize
		
	public let source: BarSource
	
	public let extendedTrading: Bool
	
	public let formatDate: Int = 1
	
	public let options: [String:String]?
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		HistoricalDataCancel(id: id)
	}

	/**
	 Creates new request to query historical data
	 - returns: 'HistoricalData' event with optional updates
	 - parameter id: unique request id
	 - parameter contract: contract
	 - parameter interval: observation period dateinterval
	 - parameter size: observation sample length (eg .day)
	 - parameter source: observation type (eg trades, bid_ask)
	 - parameter extendedTrading: include data outside the regular trading session
	 
	 - note: to enable continous updates, set interval end date as `distantFuture`
	 */
	public init(
		id: Int ,
		contract: Contract,
		interval: DateInterval,
		size: BarSize,
		source: BarSource,
		extendedTrading:Bool
	){
		self.id = id
		self.contract = contract
		self.interval = interval
		self.size = size
		self.source = source
		self.extendedTrading = extendedTrading
		self.options = nil
	}
	
	public func encode(to encoder: IBEncoder) throws {
			
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
			
		if encoder.serverVersion < .syntRealtimeBars {
			try container.encode(version)
		}
			
		try container.encode(id)
			
		// send contract fields
		if encoder.serverVersion >= .tradingClass {
			try container.encodeOptional(contract.id)
		}
			
		try container.encodeOptional(contract.symbol)
		try container.encodeOptional(contract.type)
		try container.encodeOptional(contract.expiration)
		try container.encodeOptional(contract.strike)
		try container.encodeOptional(contract.right)
		try container.encodeOptional(contract.multiplier)
		try container.encodeOptional(contract.exchange)
		try container.encodeOptional(contract.primaryExchange)
		try container.encodeOptional(contract.currency)
		try container.encodeOptional(contract.localSymbol)
			
		if encoder.serverVersion >= .tradingClass {
			try container.encodeOptional(contract.tradingClass)
		}
			
		if encoder.serverVersion.rawValue >= 31 {
			try container.encodeOptional(contract.includeExpired)
		}
		
		let keepUpdating = Calendar.current.compare(Date(), to: interval.end, toGranularity: .day) == .orderedAscending

		if encoder.serverVersion.rawValue >= 20 {
			try container.encodeOptional(keepUpdating == true ? nil : interval.end)
			try container.encode(size)
		}

		try container.encode(interval.twsDescription)
		try container.encode(extendedTrading.reverseValue())
		try container.encode(source)

		if encoder.serverVersion.rawValue > 16 {
			try container.encode(formatDate);
		}

		if contract.type == .combo {
			try container.encode(contract.comboLegs?.count ?? 0)
			if let legs = contract.comboLegs{
				for leg in legs{
					try container.encode(leg.id)
					try container.encode(leg.ratio)
					try container.encode(leg.action)
					try container.encode(leg.exchange)
				}
			}
		}

		if encoder.serverVersion >= .syntRealtimeBars {
			try container.encode(keepUpdating)
		}
			
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
			
	}
}

/**
 Cancellation of an outstanding market data request
 */
public struct HistoricalDataCancel: IdentifiableRequest{
	
	public let type: RequestType = .historicalDataCancel
	
	private let version: Int = 1

	private let minimumServerVersion: Int = 24

	public var id: Int
	
	public init(id: Int) {
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
 Delivers the requested historical data bars
 */
public struct HistoricalData: IBEvent, IBDecodable{

	/// id of originating request
	public let id: Int

	/// observation length
	public let interval: DateInterval

	/// observation results
	public let series: [Bar]
		
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = decoder.serverVersion < .syntRealtimeBars ? try container.decode(Int.self) : Int.max
		self.id = try container.decode(Int.self)
		let start = try container.decode(Date.self)
		let end = try container.decode(Date.self)
		self.interval = DateInterval(start: start, end: end)
		let count = try container.decode(Int.self)
		var buffer: [Bar] = []
		for _ in 0..<count{
			
			let date = try container.decode(Date.self)
			let open = try container.decode(Double.self)
			let high = try container.decode(Double.self)
			let low = try container.decode(Double.self)
			let close = try container.decode(Double.self)
			let volume = try container.decodeOptional(Double.self)
			let wap = try container.decodeOptional(Double.self)

			if decoder.serverVersion < .syntRealtimeBars{
				_ = try container.decodeOptional(String.self)
			}
			
			let count = version >= 3 ? try container.decode(Int.self) : nil
			
			let temp = Bar(
				date: date,
				open: open,
				high: high,
				low: low,
				close: close,
				volume: volume,
				vwap: wap,
				count: count
			)
			
			buffer.append(temp)
				
		}
		self.series = buffer
		
	}
	
}

/**
 returns updates in real time when interval end date is set to `distantFuture`
 */
public struct HistoricalDataUpdate: IBEvent, IBDecodable, Identifiable{

	/// id of originating request
	public let id: Int

	/// observation update
	public let bar: Bar
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		let date = try container.decode(Date.self)
		let open = try container.decode(Double.self)
		let close = try container.decode(Double.self)
		let high = try container.decode(Double.self)
		let low = try container.decode(Double.self)
		let wap = try container.decode(Double.self)
		let volume = try container.decode(Double.self)
		
		self.bar = Bar(
			date: date,
			open: open,
			high: high,
			low: low,
			close: close,
			volume: volume,
			vwap: wap,
			count: count
		)
	}

}




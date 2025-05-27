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
 Market data request.
 - returns: streaming or snapshot data.
 
To be eligible to receive live market data, following conditions must be met:
* trading permissions for the specified instruments
* a funded account (except with forex and bonds)
* market data subscriptions for the specified username

 This data is not tick-by-tick but consists of aggregated snapshots taken at intra-second intervals:
* Stocks, Futures and others:	250 ms
* US Options:	100 ms
* FX pairs:	5 ms

Usage Options:
 * streaming data returns continous stream of specified events. Top of the orderbook will be delivered as default
 * snapshot data returns single snapshot event per request.

 - Note:
A default 100 concurrent subscription limit can be increased by purchasing booster packs or having larger account / generating more fees.
 */

public struct MarketDataRequest: AnyCancellableRequest, IdentifiableRequest{
	
	public let type: RequestType = .marketData

	private let version:Int = 11
	
	private let minimumServerVersion: ServerVersion = .snapshotMktData
	
	public let id: Int
	
	public let contract:Contract

	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return MarketDataCancel(id: id)
	}
	
	/**
	 Specifies Market Data events to be received
	 */
	public enum EventType: Int, Codable, Sendable {
		/// call & put option volume for current session
		case optionVolume = 100
		
		/// call & put option open interest for current session
		case optionOpenInterest = 101
		
		/// 30-day historical volatility (currently for stocks).
		case optionHistoricalVolatility = 104
		
		/// average volume of the corresponding option contracts
		case averageOptionVolume = 105
		
		/**
		 A prediction of how volatile an underlying will be in the future.
		
		 The IB 30-day volatility is the at-market volatility estimated for a maturity thirty calendar days forward of the
		 current trading day, and is based on option prices from two consecutive expiration months.
		 */
		case optionImpliedVolatility = 106
		
		/// The number of points that the index is over the cash index.
		case indexFuturePremium = 162
		
		/// 13, 26 and 51 week Hi-Lo values. For stocks only.
		case highLowVolumeStats = 165
		
		/// The mark price is the current theoretical calculated value of an instrument.
		case markPrice = 221

		/**
		 Auction price, volume and imbalance
		 
		 * Price - The number of shares that would trade if no new orders were received and the auction were held now.
		 * Volume - The price at which the auction would occur if no new orders were received and the auction were held now.
		 * Imbalance - How many more shares are on one side of the auction than the other.
		 */
		case auction = 225
		
		/// Last trade details (Including both "Last" and "Unreportable Last" trades).
		case realTimeVolumeTimeAndSales = 233

		/// Level of difficulty with which the contract can be sold short & number of shares available to short
		case shortable = 236
		
		/// Contract's news feed.
		case news = 292
		
		/// Trade count for the day.
		case tradeCount = 293
		
		/// Trade count per minute.
		case tradeRate = 294
		
		/// Volume per minute.
		case volumeRate = 295
		
		/// Last Regular Trading Hours traded price.
		case lastRTHTrade = 318
		
		///Last trade details that excludes "Unreportable Trades"
		case realTimeTradeVolume = 375
		
		///30-day real time historical volatility.
		case realTimeHistoricalVolatility = 411

		/// Contract's dividends
		case dividends = 456
		
		/// The bond factor is a number that indicates the ratio of the current bond principal to the original principal
		case bondFactorMultiplier = 460
		
		/// Estimated IPO price range and final price
		case ipoData = 586
		
		/// Total number of outstanding futures contracts
		case futuresOpenInterest = 588
		
		/// 3, 5 and 10 min trading volume
		case shortTermVolume = 595
		
		/// BID and ASK values of etf Net Asset Value. Calculation is based on prices of ETF's underlying securities.
		case navBidAsk = 576
		
		/// LAST price of etf Net Asset Value. Calculation is based on prices of ETF's underlying securities.
		case etfNavLast = 577
		
		/// Today's and previous closing price of ETF contract. Calculation is based on prices of ETF's underlying securities.
		case etfNavClose = 578
		
		/// Hi-Lo values for ETF contract
		case etfNavHighLow = 614
		
		/// ETF Nav Last for Frozen data
		case etfNavFrozenLast = 623
		
		/// Slower mark price update used in system calculations
		case creditmanSlowMarkPrice = 619
	}
	
	public let events: [EventType]
	
	public let snapshot: Bool
	
	public let regulatorySnapshot:Bool
	
	public let options:[String:String]?
	
	/**
	 Creates a new market data request
	 
	 - returns: tick objects (`TickPrice`, `TickSize`, etc) depending on passed event types
	 - parameter id: unique request id.
	 - parameter contract: contract, for which market data is being requested
	 - parameter events: array of `EventType` values. Only for streaming data.
	 - parameter snapshot: request a snapshot of the current state of the market once instead of requesting a streaming data
	 - parameter regulatory: with the US Value Snapshot Bundle for stocks, regulatory snapshots are available for 0.01 USD each.
	 
	 - note: Market data responses do not have any contract info and are identified by matching identifier only.
	 So you need to pair the responses for this request to get context.
	 
	 - important: if you want snapshots, do not specify any events.
	 */
		
	public init(
		id: Int,
		contract:Contract ,
		events: [EventType] = [],
		snapshot: Bool = false,
		regulatory: Bool = false
	) {
		self.id = id
		self.contract = contract
		self.events = events
		self.snapshot = snapshot
		self.regulatorySnapshot = regulatory
		self.options = nil
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
			
		if encoder.serverVersion >= .reqMktDataConid {
			try container.encodeOptional(contract.id)
		}
			
		try container.encodeOptional(contract.symbol)
		try container.encodeOptional(contract.type)
		try container.encodeOptional(contract.expiration)
		try container.encodeOptional(contract.strike)
		try container.encodeOptional(contract.right)
		
		if encoder.serverVersion.rawValue >= 15 {
			try container.encodeOptional(contract.multiplier)
		}
			
		try container.encodeOptional(contract.exchange)
		
		if encoder.serverVersion.rawValue >= 14 {
			try container.encodeOptional(contract.primaryExchange)
		}
			
		try container.encodeOptional(contract.currency)
		
		if encoder.serverVersion.rawValue >= 2 {
			try container.encodeOptional(contract.localSymbol)
		}
			
		if encoder.serverVersion >= .tradingClass {
			try container.encodeOptional(contract.tradingClass)
		}
			
		if contract.type == .combo {
			try container.encode(contract.comboLegs?.count ?? 0)
			if let legs = contract.comboLegs{
				for leg in legs {
					try container.encodeOptional(leg.id)
					try container.encodeOptional(leg.ratio)
					try container.encodeOptional(leg.action)
					try container.encodeOptional(leg.exchange)
				}
			}
		}
															
		if encoder.serverVersion >= .deltaNeutral {
			if let temp = contract.deltaNeutralContract {
				try container.encodeOptional(true)
				try container.encodeOptional(temp.id)
				try container.encodeOptional(temp.delta)
				try container.encodeOptional(temp.price)
			} else {
				try container.encodeOptional(false)
			}
		}
		
		if encoder.serverVersion.rawValue >= 31 {
			let list: String = events.compactMap({"\($0.rawValue)"}).joined(separator: ",")
			try container.encodeOptional(list)
		}
			
		if encoder.serverVersion >= .snapshotMktData {
			try container.encode(snapshot)
		}
			
		if encoder.serverVersion >= .reqSmartComponents {
			try container.encode(regulatorySnapshot)
		}
			
		// send mktDataOptions parameter
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
			
		
	}
}



/**
 Request to cancel market data
 - parameter id: identifier of request to be cancelled
 */

public struct MarketDataCancel: IdentifiableRequest{
	
	public let type: RequestType = .marketDataCancel

	private let version:Int = 1

	public let id: Int

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





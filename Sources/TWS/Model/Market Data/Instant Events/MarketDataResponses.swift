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

public protocol AnyTick{
	var tickType: TickType { get }
}

/**
 Delivers last price and size event of bid, ask or trade
 */
public struct TickQuote: IBEvent, IBDecodable, AnyTick, Identifiable{

	public let id: Int

	public let tickType: TickType

	public let quote: Quote?

	public let attributes: [TickAttributes]?
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		let mask = try container.decodeOptional(Int.self)


		var attr: [TickAttributes] = []
			
		if let mask = mask{
			if decoder.serverVersion >= .pastLimit {
				if mask & 1 != 0 { attr.append(.canAutoExecute) }
				if mask & 2 != 0 { attr.append(.pastLimit) }
			}
			
			if decoder.serverVersion >= .preOpenBidAsk {
				if mask & 4 != 0 {attr.append(.preOpen) }
			}
		}
			
		if price != -1 && size != -1 {
			self.quote = Quote(price: price, size: size)
			self.attributes = attr
		} else {
			self.quote = nil
			self.attributes = nil
		}

	}
	
}



/**
 Market data tick price callback. Mainly price statistics related updades
 */
public struct TickPrice: IBEvent, IBDecodable, AnyTick, Identifiable{

	public let id: Int

	public let tickType: TickType

	public let price: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		self.price = try container.decode(Double.self)
		
	}
	
}


/**
 Market data tick size callback. Handles all size-related ticks.
 */
public struct TickSize: IBEvent, IBDecodable, AnyTick, Identifiable{

	public let id: Int

	public let tickType: TickType

	public let size: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		self.size = try container.decode(Double.self)

	}
	
}




public struct TickGeneric: IBEvent, IBDecodable, AnyTick, Identifiable{

	public let id: Int
   
	public let tickType: TickType
   
	public let value: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		self.value = try container.decode(Double.self)
	}
	
}



public struct TickString: IBEvent, IBDecodable, AnyTick, Identifiable{

	public let id: Int
   
	public let tickType: TickType
   
	public let value: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		self.value = try container.decode(String.self)
	}
	
}

/**
market data call back for Exchange for Physical
   tickerId -      The request's identifier.
   tickType -      The type of tick being received.
   basisPoints -   Annualized basis points, which is representative of the financing rate that can be directly compared to broker rates.
   formattedBasisPoints -  Annualized basis points as a formatted string that depicts them in percentage form.
   impliedFuture - The implied Futures price.
   holdDays -  The number of hold days until the lastTradeDate of the EFP.
   futureLastTradeDate -   The expiration date of the single stock future.
   dividendImpact - The dividend impact upon the annualized basis points interest rate.
   dividendsToLastTradeDate - The dividends expected until the expiration of the single stock future.
*/
public struct TickEFP: IBEvent, IBDecodable, AnyTick, Identifiable {
	
	public let id: Int

	public let tickType: TickType

	public let basisPoints: Double

	public let formattedBasisPoints: String

	public let impliedFuturesPrice: Double

	public let holdDays: Int

	public let futureLastTradeDate: String

	public let dividendImpact: Double

	public let dividendsToLastTradeDate: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		self.basisPoints = try container.decode(Double.self)
		self.formattedBasisPoints = try container.decode(String.self)
		self.impliedFuturesPrice = try container.decode(Double.self)
		self.holdDays = try container.decode(Int.self)
		self.futureLastTradeDate = try container.decode(String.self)
		self.dividendImpact = try container.decode(Double.self)
		self.dividendsToLastTradeDate = try container.decode(Double.self)
	}
	
}


/**
returns news headlines
*/
public struct TickNews: IBEvent, IBDecodable, AnyTick, Identifiable{

	public let tickType: TickType

	public let id: Int
   
	public let timestamp: Int

	public let providerCode: String

	public let articleId: String
   
	public let headline: String
   
	public let extraData: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.timestamp = try container.decode(Int.self)
		self.providerCode = try container.decode(String.self)
		self.articleId = try container.decode(String.self)
		self.headline = try container.decode(String.self)
		self.extraData = try container.decode(String.self)
		self.tickType = .news
	}
	
}



/**
This function is called when the market in an option or its
underlier moves. TWS's option model volatilities, prices, and
deltas, along with the present value of dividends expected on that
options underlier are received.
*/
public struct TickOptionComputation: IBEvent, IBDecodable, AnyTick, Identifiable {
	
	public let id: Int
	
	public let tickType: TickType
	
	public let tickAttrib: Int
	
	public let impliedVol: Double?
	
	public let delta: Double?
	
	public let optPrice: Double?
	
	public let pvDividend: Double?
	
	public let gamma: Double?
	
	public let vega: Double?
	
	public let theta: Double?
	
	public let undPrice: Double?

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()

		let version = decoder.serverVersion >= .priceBasedVolatility ? Int.max : try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)

		if decoder.serverVersion >= .priceBasedVolatility {
			self.tickAttrib = try container.decode(Int.self)
		} else {
			self.tickAttrib = 0 // or another default
		}

		let impliedVol = try container.decode(Double.self)
		self.impliedVol = impliedVol == -1 ? nil : impliedVol

		let delta = try container.decode(Double.self)
		self.delta = delta == -2 ? nil : delta

		if version >= 6 || tickType == .modelOption || tickType == .delayedModelOption {
			let optPrice = try container.decode(Double.self)
			self.optPrice = optPrice == -1 ? nil : optPrice

			let pvDividend = try container.decode(Double.self)
			self.pvDividend = pvDividend == -1 ? nil : pvDividend
		} else {
			self.optPrice = nil
			self.pvDividend = nil
		}

		if version >= 6 {
			let gamma = try container.decode(Double.self)
			self.gamma = gamma == -2 ? nil : gamma

			let vega = try container.decode(Double.self)
			self.vega = vega == -2 ? nil : vega

			let theta = try container.decode(Double.self)
			self.theta = theta == -2 ? nil : theta

			let undPrice = try container.decode(Double.self)
			self.undPrice = undPrice == -1 ? nil : undPrice
		} else {
			self.gamma = nil
			self.vega = nil
			self.theta = nil
			self.undPrice = nil
		}
	}
}

   

public struct TickDividends: IBEvent, IBDecodable , AnyTick, Identifiable{
		
	public let id: Int
	
	public var tickType: TickType
		
	/// The sum of dividends for the past 12 months.
	public let paid: Double
	
	/// The sum of dividends for the next 12 months.
	public let expected: Double
	
	/// The next dividend date
	public let nextDate: String
	
	/// The next single dividend amount.
	public let nextAmount: Double
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
		tickType = try container.decode(TickType.self)
		
		let components = try container.decode(String.self).components(separatedBy: ",")
		
		decoder.dateDecodingStrategy = .eodPriceHistoryFormat
		guard components.count == 4,
			  let paid = Double(components[0]),
			  let expected = Double(components[1]),
			  let nextAmount = Double(components[3])
		else {
			throw  IBError.decodingError("failed to decode dividend info")
		}
		
		self.paid = paid
		self.expected = expected
		self.nextDate = components[2]
		self.nextAmount = nextAmount
	}
	
}


///The shortable tick is an indicative on the amount of shares which can be sold short for the contract:
///
public struct ShortSaleAvailability: IBEvent, IBDecodable, AnyTick, Identifiable{
	
	public let id: Int
	
	public let tickType: TickType


	public enum Availability: Sendable{
		/// There are at least 1000 shares available for short selling.
		case shortable
		
		/// This contract will be available for short selling if shares can be located
		case locatable
		
		/// Contract is not available for short selling.
		case notShortable
	}
	
	public let availability: Availability
			
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
		tickType = try container.decode(TickType.self)
		let value = try container.decode(Double.self)
		switch value {
		case 0...1.5: 		self.availability = .notShortable
		case 1.5...2.5: 	self.availability = .locatable
		default:			self.availability = .shortable
		}
	}
		
}


/// The RT Volume tick type corresponds to the TWS’ Time & Sales window and contains
public struct RTVolumeSales: IBEvent, IBDecodable, AnyTick, Identifiable {
		
	public var id: Int
	
	public let tickType: TickType
	
	/// last trade’s price
	public let price: String
	
	/// last trade size
	public let size: String
	
	/// last trade time
	public let timestamp: String
	
	/// current day’s total traded volume,
	public let totalVolume: String
	
	/// Volume Weighted Average Price (VWAP)
	public let vwap: String
	
	/// indicates whether or not the trade was filled by a single market maker.
	public let singleTrade: String

	
	public init(from decoder: IBDecoder) throws {

		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
		tickType = try container.decode(TickType.self)

		let components = try container.decode(String.self).components(separatedBy: ";")
		guard components.count == 6
		else { throw  IBError.decodingError("failed to decode RT VOLUME SALES info") }
		
		self.price = components[0]
		self.size = components[1]
		self.timestamp = components[2]
		self.totalVolume = components[3]
		self.vwap = components[4]
		self.singleTrade = components[5]
	}
}


public struct TickTimestamp: IBEvent, IBDecodable, AnyTick, Identifiable {

	public var id: Int

	public var tickType: TickType

	public var timestamp: Double
		
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
		tickType = try container.decode(TickType.self)

		self.timestamp = try container.decode(Double.self)
	}
	
}




/**
returns exchange map of a particular contract
*/
public struct TickReqParams: IBEvent, IBDecodable, Identifiable{

	public let id: Int
   
	public let minTick: Double
   
	public let bboExchange: String
   
	public let snapshotPermissions: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.minTick = try container.decode(Double.self)
		self.bboExchange = try container.decode(String.self)
		self.snapshotPermissions = try container.decode(Int.self)
	}
	
}





/**
returns reroute CFD contract information for market data request
*/
public struct RerouteMktDataReq: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let contractId: Int

	public let exchange: String

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.contractId = try container.decode(Int.self)
		self.exchange = try container.decode(String.self)
	}
	
}


/**
returns reroute CFD contract information for market depth request
*/
public struct RerouteMktDepthReq: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let contractId: Int

	public let exchange: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.contractId = try container.decode(Int.self)
		self.exchange = try container.decode(String.self)
	}
	
}



public struct TickExchange: IBEvent, IBDecodable, AnyTick, Identifiable {

	public let id: Int

	public let tickType: TickType

	public var exchange: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.tickType = try container.decode(TickType.self)
		self.exchange = try container.decode(String.self)
	}
	
}


public struct TradingStatus: IBEvent, IBDecodable, AnyTick, Identifiable{
	
	public let id: Int
	
	public let tickType: TickType

	public enum Status: Int, Sendable {
		
		/// Status not available. Usually returned with frozen data.
	 case unknown = -1
	 
	 /// This value will only be returned if the contract is in a TWS watchlist.
	 case notHalted = 0
	 
	 /// Trading halt is imposed for purely regulatory reasons with/without volatility halt.
	 case general = 1
	 
	 /// Trading halt is imposed by the exchange to protect against extreme volatility.
	 case volatility = 2
	 
 }
	
	public let status: Status
			
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
		tickType = try container.decode(TickType.self)
		let value = try container.decode(Double.self)
		switch value {
		case 0.0: 	self.status = .notHalted
		case 1.0:	self.status = .general
		case 2.0:	self.status = .volatility
		default:	self.status = .unknown
		}
	}
		
}


/**
 When requesting market data snapshots, this market will indicate the snapshot reception is finished.
*/
public struct TickSnapshotEnd: IBEvent, IBDecodable, Identifiable{

	public let id: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		id = try container.decode(Int.self)
	}
	
}

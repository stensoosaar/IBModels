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


public enum MarketDataType: Int, Sendable, Codable{
	/**
	 Live market data is streaming data relayed back in real time.
	- important:
	 Market data subscriptions are required to receive live market data.
	 */
	case realtime = 1
	
	/**
	 Frozen market data is the last data recorded at market close.
	 
	 When you set the market data type to Frozen, you are asking TWS to send the last available quote when there is not one currently available.
	 
	 For instance, if a market is currently closed and real time data is requested, -1 values will commonly be returned for the bid and ask prices to indicate there is no current bid/ask data available.
	 To receive the last know bid/ask price before the market close, switch to market data type 2 from the API before requesting market data.
	 */
	case frozen = 2
	
	/**
	 Free, delayed data is 15 - 20 minutes delayed for contracts where market data subscription is missing.
	 
	 If live data is available a request for delayed data would be ignored by TWS.
	 Delayed market data is returned with delayed Tick Types.
	 */
	case delayed = 3
	
	/**
	 Requests delayed "frozen" data for a user without market data subscriptions.
	 */
	case delayedFrozen = 4
}



/**
 Creates request to change market data type
 */
public struct MarketDataTypeRequest: AnyRequest {
	
	public let type: RequestType = .marketDataType

	private let version: Int = 1

	private let minimumServerVersion: ServerVersion = .reqMarketDataType

	public let marketDataType: MarketDataType
	
	public init(marketDataType: MarketDataType){
		self.marketDataType = marketDataType
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(marketDataType)
	}
}


/**TWS sends a marketDataType{type) callback to the API, where
type is set to Frozen or RealTime, to announce that market data has been
switched between frozen and real-time. This notification occurs only
when market data switches between real-time and frozen. The
marketDataType{ ) callback accepts a reqId parameter and is sent per
every subscription because different contracts can generally trade on a
different schedule.*/

public struct CurrentMarketDataType: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let currentMode: MarketDataType
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.currentMode = try container.decode(MarketDataType.self)
	}
	

}



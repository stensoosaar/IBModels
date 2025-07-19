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
	Defines event type we observe when building the bars
	- Note: Availability of each bar source varies by product type (e.g., Stocks, Options, Futures, Crypto).
 */
public enum BarSource: String, Sendable, Codable {
	/// Trades: Last trade price. 
	/// - Available for: all except commodities, forex, funds, cfd
	/// - Adjusted for splits; not adjusted for dividends.
	case trades = "TRADES"
	
	/// Midpoint: Midpoint between bid and ask.
	/// - Available for: all except indicies
	case midPoint = "MIDPOINT"
	
	/// Bid: Best bid price.
	/// - Available for: all except indicies
	case bid  = "BID"
	
	/// Ask: Best ask price.
	/// - Available for: all except indicies
	case ask = "ASK"
	
	/// Bid/Ask: Both bid and ask, used for constructing bid/ask bars.
	/// - Available for: all except indicies
	case bidAsk = "BID_ASK"
	
	/// Adjusted Last: Last trade price adjusted for splits and dividends.
	/// - Available for: Stocks
	case adjustestLast = "ADJUSTED_LAST"
	
	/// Historical Volatility: Calculated historical volatility value per bar.
	/// - Available for: Stocks, ETF's, Indices
	case historicalVolatility = "HISTORICAL_VOLATILITY"
	
	/// Option Implied Volatility: Calculated implied volatility from option prices.
	/// - Available for: Stocks, ETF's, Indices
	case impliedVolatility = "OPTION_IMPLIED_VOLATILITY"
	
	/// Fee Rate: Applicable fee rate for the product.
	/// - Available for: Crypto, some Futures
	case feeRate = "FEE_RATE"
	
	/// Yield Bid: Bid yield value.
	/// - Available for: Bonds
	case bidYield = "YIELD_BID"
	
	/// Yield Ask: Ask yield value.
	/// - Available for: Bonds
	case askYield = "YIELD_ASK"
	
	/// Yield Bid/Ask: Both bid and ask yields.
	/// - Available for: Bonds
	case bidAskYield = "YIELD_BID_ASK"
	
	/// Last Yield: Last transacted yield.
	/// - Available for: Bonds
	case lastYield = "YIELD_LAST"
	
	/// Schedule: Historical trading schedule; provides trading hours for the instrument. No OHLCV data.
	/// - Available for: all except options, FOP's,
	case schedule = "SCHEDULE"
	
	/// Aggregated Trades: Aggregated trade data from crypto exchanges.
	/// - Available for: Crypto
	case aggregatedTrades = "AGGTRADES"
	
}

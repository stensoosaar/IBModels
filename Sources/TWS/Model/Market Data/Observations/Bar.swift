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
Bar represents statistical collection of stacked instant events (i.e. trades, bid, ask, midpoint)
Usual types are constant time or constant volume bars
*/
public struct Bar: AnyBar, Sendable{
	
	/// observation start date
	public let date: Date
	
	/// observation first price
	public let open: Double
	
	/// observation max value
	public let high: Double
	
	/// observation min value
	public let low: Double
	
	// observation last value
	public let close: Double
	
	///The bar’s traded volume if available
	/// - note: only available for TRADES
	public let volume: Double?
	
	///The bar’s Weighted Average Price
	/// - note: only available for TRADES
	public let vwap: Double?
	
	///The number of trades during the bar’s timespan
	/// - note: only available for TRADES
	public let count: Int?
	
}




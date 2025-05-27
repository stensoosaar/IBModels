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



public protocol AnyContract {
	
	/// The unique IB contract identifier.
	var id: Int? {get set}

	///The security’s type:
	var type: Contract.SecuritiesType? {get set}

	/// The underlying’s asset symbol.
	var symbol: String? {get set}
	
	/// The underlying’s currency.
	var currency: String? {get set}
	
	///The contract’s last trading day.
	var expiration: DateComponents? {get set}
		
	var lastTradeDate: Date? {get set}

	///The option’s strike price.
	var strike: Double? {get set}
	
	///Either Put or Call (i.e. Options). Valid values are P, PUT, C, CALL.
	var right: Contract.ExecutionRight? {get set}
	
	///The instrument’s multiplier (i.e. options, futures).
	var multiplier: Double? {get set}
	
	///The destination exchange.
	var exchange: String? {get set}
	
	/**
	 The contract’s primary exchange. For smart routed contracts, used to define contract in case of ambiguity.Should be defined as native exchange of contract. For exchanges which contain a period in name, will only be part of exchange name prior to period, i.e. ENEXT for ENEXT.BE
	 */
	var primaryExchange: String? {get set}
	
	/// The contract’s symbol within its primary exchange. For options, this will be the OCC symbol
	var localSymbol: String? {get set}
	
	/**
	 The trading class name for this contract. Available in TWS contract description window as well.
	 For example, GBL Dec ’13 future’s trading class is “FGBL”
	 */
	var tradingClass: String? {get set}
	
	var globalID: Contract.GlobalIdentifier? {get set}
	
	
}


extension AnyContract where Self: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		
		if let left = lhs.id, let right = rhs.id{
			return left == right
		}
		
		if let left = lhs.globalID, let right = rhs.globalID {
			return left == right
		}
		
		if lhs.type != rhs.type { return false }
		
		if lhs.symbol?.uppercased() != rhs.symbol?.uppercased() { return false }
		
		if lhs.currency?.uppercased() != rhs.currency?.uppercased() { return false }
		
		if lhs.strike != rhs.strike { return false }
		
		if rhs.right != lhs.right { return false }
		
		if let left = lhs.lastTradeDate, let right = rhs.lastTradeDate {
			if Calendar.current.compare(left, to: right, toGranularity: .day) != .orderedSame {
				return false
			}
		}
		
		return true
		
	}
}

extension AnyContract where Self: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(type?.rawValue)
		hasher.combine(symbol?.uppercased())
		hasher.combine(currency?.uppercased())
		hasher.combine(lastTradeDate)
		hasher.combine(strike)
		hasher.combine(right)
	}
	
}

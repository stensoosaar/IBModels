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
 Think Contract as a reference or query to financial instrument, not financial instrument itself.
*/
public struct Contract: AnyContract, Sendable, Hashable, Equatable, Identifiable {	
	
	/// The unique IB contract identifier.
	public var id: Int?
	
	///The security’s type:
	public var type: SecuritiesType?

	/// The underlying’s asset symbol.
	public var symbol: String?
	
	/// The underlying’s currency.
	public var currency: String?
	
	///The contract’s last trading day.
	public var expiration: DateComponents?
	
	public var lastTradeDate: Date?
		
	///The option’s strike price.
	public var strike: Double?
	
	public enum ExecutionRight:String, Sendable, Codable{
		case call = "C"
		case put = "P"
	}
	
	///Either Put or Call (i.e. Options). Valid values are P, PUT, C, CALL.
	public var right: ExecutionRight?
	
	///The instrument’s multiplier (i.e. options, futures).
	public var multiplier: Double?
	
	///The destination exchange.
	public var exchange: String?
	
	/**
	 The contract’s primary exchange. For smart routed contracts, used to define contract in case of ambiguity.Should be defined as native exchange of contract. For exchanges which contain a period in name, will only be part of exchange name prior to period, i.e. ENEXT for ENEXT.BE
	 */
	public var primaryExchange: String?
	
	/// The contract’s symbol within its primary exchange. For options, this will be the OCC symbol
	public var localSymbol: String?
	
	/**
	 The trading class name for this contract. Available in TWS contract description window as well.
	 For example, GBL Dec ’13 future’s trading class is “FGBL”
	 */
	public var tradingClass: String?
		
	/// Security’s identifier when querying contract’s details or placing orders ISIN – Example: Apple: US0378331005
	public var globalID: GlobalIdentifier?
	
	///Description of the contract.
	public var description: String?
	
	///IssuerId of the contract.
	public var issuerId: String?

	internal var deltaNeutralContract: DeltaNeutralContract?

	///If set to true, contract details requests and historical data queries can be performed pertaining to expired futures contracts. Expired options or other instrument types are not available.
	public var includeExpired: Bool = false

	///The legs of a combined contract definition. More…
	internal var comboLegsDescrip: String?

	///Description of the combo legs.
	internal var comboLegs: [ComboLeg]?

	
	public init(
		id: Int? = nil,
		type: SecuritiesType? = nil,
		symbol: String? = nil,
		currency: String? = nil,
		expiration: DateComponents? = nil,
		strike: Double? = nil,
		right: ExecutionRight? = nil,
		multiplier: Double? = nil,
		exchange: String? = nil,
		primaryExchange: String? = nil,
		localSymbol: String? = nil,
		tradingClass: String? = nil,
		globalID: GlobalIdentifier? = nil,
		includeExpired: Bool = false
	) {
		self.id = id
		self.type = type
		self.symbol = symbol
		self.currency = currency
		self.expiration = expiration
		self.strike = strike
		self.right = right
		self.multiplier = multiplier
		self.exchange = exchange
		self.primaryExchange = primaryExchange
		self.localSymbol = localSymbol
		self.tradingClass = tradingClass
		self.globalID = globalID
		self.includeExpired = includeExpired
	}
	
	
}


extension Contract: IBCodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.symbol = try container.decode(String.self)
		self.type = try container.decode(SecuritiesType.self)
		self.expiration = try container.decodeOptional(DateComponents.self)
		self.strike = try container.decodeOptional(Double.self)
		self.right = try container.decodeOptional(ExecutionRight.self)
		self.multiplier = try container.decodeOptional(Double.self)
		self.exchange = try container.decodeOptional(String.self)
		self.currency = try container.decode(String.self)
		self.localSymbol = try container.decodeOptional(String.self)
		self.tradingClass = try container.decodeOptional(String.self)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encodeOptional(id ?? 0)
		try container.encodeOptional(symbol)
		try container.encodeOptional(type)
		try container.encodeOptional(expiration)
		try container.encodeOptional(strike ?? 0)
		try container.encodeOptional(right)
		try container.encodeOptional(multiplier ?? 0)
		try container.encodeOptional(exchange)
		try container.encodeOptional(primaryExchange)
		try container.encodeOptional(currency)
		try container.encodeOptional(localSymbol)
		try container.encodeOptional(tradingClass)
	}
	
}

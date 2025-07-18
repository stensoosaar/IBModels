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
 Requests security definition option parameters for viewing a  contract's option chain
  */
public struct OptionParametersRequest: IdentifiableRequest {
	
	public let type: RequestType = .optionParameters
	
	private let minimumServerVersion: ServerVersion = .secDefOptParamsReq

	/// request id
	public let id: Int
	
	/// underlying contract id
	public let underlyingId: Int

	/// underlying contract symbol
	public let underlyingSymbol: String
	
	/// underlying contract type
	public let underlyingType: SecuritiesType

	public let futFopExchange: String?
			
	/**
	 
	 - returns: one or many `OptionContractDetails` messages
	 - parameter id: unique request id
	 - parameter underlyingId: underlying contract id (eg. 265598)
	 - parameter underlyingSymbol: underlying contract symbol(eg. AAPL)
	 - parameter underlyingType: underlying contract type (eg. .stock)
	 - parameter futFopExchange: fill only to get back chain of options on futures
	 */
	public init(
		id: Int,
		underlyingId: Int,
		underlyingSymbol: String,
		underlyingType: SecuritiesType,
		futFopExchange:String? = nil
	){
		self.id = id
		self.underlyingSymbol = underlyingSymbol
		self.futFopExchange = futFopExchange
		self.underlyingType = underlyingType
		self.underlyingId = underlyingId
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(underlyingSymbol)
		try container.encodeOptional(futFopExchange)
		try container.encode(underlyingType)
		try container.encode(underlyingId)
	}
}


/**
 Returns the option chain for an underlying on an exchange specified in `OptionParametersRequest`
 there will be multiple callbacks to if multiple exchanges are specified
 */
public struct OptionContractDetails: IBEvent, IBDecodable, Identifiable{

	/// id of the originating request
	public let id: Int
	
	/// exchange where option is traded
	public let exchange: String

	///The conID of the underlying security
	public let underlyingConId: Int

	///the option trading class
	public let tradingClass: String

	///  the option multiplier
	public let multiplier: Double

	/// a list of the expiries for the options of this underlying on this exchange
	public let expirations: [Date]

	/// a list of the possible strikes for options of this underlying on this exchange
	public let strikes: [Double]
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.exchange =  try container.decode(String.self)
		self.underlyingConId = try container.decode(Int.self)
		self.tradingClass =  try container.decode(String.self)
		self.multiplier =  try container.decode(Double.self)
		let expirationsCount = try container.decode(Int.self)
		var expirationBuffer: [Date] = []
		var strikeBuffer: [Double] = []
		
		for _ in 0..<expirationsCount {
			let date = try container.decode(Date.self)
			expirationBuffer.append(date)
		}
		
		let strikesCount = try container.decode(Int.self)

		for _ in 0..<strikesCount {
			let strike = try container.decode(Double.self)
			strikeBuffer.append(strike)
		}

		self.expirations = expirationBuffer
		self.strikes = strikeBuffer
		
	}
	
}




/**
Indicates that all `OptionContractDetails` are delivered
 */
public struct OptionContractDetailsEnd: IBEvent, IBDecodable, Identifiable{

	public let id: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
	}
	
}

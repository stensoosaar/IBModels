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




public struct OptionPriceRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .calcOptionPrice

	private let version:Int = 2

	private let minimumServerVersion: ServerVersion = .reqCalcOptionPrice

	public let id: Int
	
	public let contract: Contract
	
	public let volatility: Double
	
	public let underlyingPrice: Double
	
	public let options: [String:String]?

	/**
	 
	 - returns:
	 - parameter id: unique request id
	 - parameter contract: contract
	 - parameter volatility: volatility
	 - parameter underlyingPrice: unlerlying asset price
	 
	 */
	public init (
		id: Int,
		contract: Contract,
		volatility: Double,
		underlyingPrice: Double,
	) {
		self.id = id
		self.contract = contract
		self.volatility = volatility
		self.underlyingPrice = underlyingPrice
		self.options = nil
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return OptionPriceCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(contract)
			
		try container.encode(volatility)
		try container.encode(underlyingPrice)
			
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
	}
}

/**
 Request to cancel`OptionPriceRequest`
 */
public struct OptionPriceCancel: AnyRequest, IdentifiableRequest {
	
	public let type: RequestType = .calcOptionPriceCancel

	private let version:Int = 1

	private let minimumServerVersion: ServerVersion = .reqCalcOptionPrice

	public let id: Int

	/**
	 Creates request to cancel outstanding OptionPriceRequest
	 - parameter id: id of request to be cancelled
	 */
	public init(id: Int){
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
}

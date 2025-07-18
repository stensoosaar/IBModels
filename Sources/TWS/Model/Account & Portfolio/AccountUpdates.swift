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
 A request to subscribe balance and position updates for specified account
 
 All account values and positions will be returned initially, and then there will only be updates when there is a change in a position, or to an account value every 3 minutes if it has changed.
 
 Only one account can be subscribed at a time. A second subscription request for another account when the previous one is still active will cause the first one to be canceled in favor of the second one.
 - note: Use `AccountUpdatesRequest.cancel` to stop receiving updates.
*/
public struct AccountUpdatesRequest: AnyCancellableRequest {
	
	public let type: RequestType = .accountUpdate

	private let version:Int = 2

	public let subscribe: Bool
	
	/// Account identifier
	public let accountName: String
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return AccountUpdatesRequest(accountName: accountName, subscribe: false)
	}

	/**
	 Creates new request or single account balance and position updates
	 - returns:`AccountUpdate` , `AccountUpdateEnd` and `PositionUpdate`
	 - parameter accountName: identifier of an account to be subscribed
	 */
	public init(accountName: String) {
		self.init(accountName: accountName, subscribe: true)
	}
	
	/**
	 Creates new request or single account balance and position updates
	 - returns:`AccountUpdate` , `AccountUpdateEnd` and `PositionUpdate`
	 - parameter accountName: identifier of an account to be subscribed
	 - parameter subscribe: starts or stops the subscription for the specified account id
	 */
	public init(accountName: String, subscribe: Bool) {
		self.subscribe = subscribe
		self.accountName = accountName
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		
		try container.encode(type)
		try container.encode(version)
		try container.encode( subscribe)
			
		if encoder.serverVersion.rawValue >= 9 {
			try container.encode( accountName)
		}
	}
}


/**
 Delivers Account Update event
 */
public struct AccountUpdate<T>: AccountKeyValueUpdate where T: Decodable & Sendable {
	
	public typealias Key = AccountUpdateKeys

	/// The account identifier
	public let accountName: String
	
	/// updated account parameter
	public let key: Key
	
	/// updated parameter value
	public let value: T
	
	/// specifies currency, if the value is monetary unit
	public let currency: String?
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.key = try container.decode(AccountUpdateKeys.self)
		self.value = try container.decode(T.self)
		self.currency = try container.decodeOptional(String.self)
		self.accountName = try container.decode(String.self)
	}
}

/*
 This is called after the first batch `AccountUpdate` and `PositionUpdate` is delivered.
 */
public struct AccountUpdateEnd:  AnyAccountValueUpdate{
	
	/// The account identifier
	public let accountName: String
   
	public init(from decoder: IBDecoder) throws {
	   var container = try decoder.unkeyedContainer()
	   _ = try container.decode(Int.self)
	   self.accountName = try container.decode(String.self)
	}
   
}


/**
 Describes account last update time
 */
public struct AccountUpdateTime: AnyAccountUpdate {

	public let date: Date
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let timeString = try container.decode(String.self)
		let components = timeString.components(separatedBy: ":")
		
		guard let minuteString = components.first, let minutes = Double(minuteString),
			let secondsString = components.last, let seconds = Double(secondsString) else {
			throw IBError.decodingError("Unable to parse account update time")
		}
		
		self.date = Date().startOfDay.addingTimeInterval(minutes * 60 + seconds)
	}
	
}


/**
 Deilver an open position update
 */
public struct PositionUpdate: AnyAccountValueUpdate {
		
	/// account identifier where the position is held
	public let accountName: String
	
	/// describes the contract where
	public let contract: Contract
	
	/// how many contracts we have open
	public let units: Double
	
	/// position average opening price
	public let unitPrice: Double
	
	/// position market price
	public let marketPrice: Double
	
	/// current market value
	public let marketValue: Double
	
	/// unrealised profit or loss
	public let unrealizedPNL: Double
	
	/// realised profit or loss during the curreny session
	public let realizedPNL: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)

		var temp = Contract()
		temp.id = try container.decode(Int.self)
		temp.symbol = try container.decode(String.self)
		temp.type = try container.decode(SecuritiesType.self)
		temp.expiration = try container.decodeOptional(DateComponents.self)
		temp.strike = try container.decodeOptional(Double.self)
		temp.right = try container.decodeOptional(Contract.ExecutionRight.self)

		if version >= 7{
			temp.multiplier = try container.decodeOptional(Double.self)
			temp.primaryExchange = try container.decodeOptional(String.self)
		}

		temp.currency = try container.decodeOptional(String.self)
		temp.localSymbol = try container.decodeOptional(String.self)
		
		if version >= 8{
			temp.tradingClass = try container.decodeOptional(String.self)
		}

		self.units = try container.decode(Double.self)
		self.marketPrice = try container.decode(Double.self)
		self.marketValue = try container.decode(Double.self)
		self.unitPrice = try container.decode(Double.self) / (temp.multiplier ?? 1)
		self.unrealizedPNL = try container.decode(Double.self)
		self.realizedPNL = try container.decode(Double.self)
		self.accountName = try container.decode(String.self)
		if version == 6 &&  decoder.serverVersion.rawValue == 39 {
			temp.primaryExchange = try container.decode(String.self)
		}
		self.contract = temp
	}
	
}



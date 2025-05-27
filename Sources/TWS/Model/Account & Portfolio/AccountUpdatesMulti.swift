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
 A request to subscribe balance and position updates for specified account.
 
 All account values and positions will be returned initially, and then there will only be updates when there is a change in a position, or to an account value every 3 minutes if it has changed.
 */
public struct AccountUpdatesMultiRequest: AnyCancellableRequest, IdentifiableRequest {
	
	private let version:Int = 1

	public let type: RequestType = .accountUpdatesMulti
	
	private let minimumServerVersion: ServerVersion = .modelsSupport

	public let id: Int
	
	public let accountName: String
	
	public let modelCode: String?
	
	public let ledgerAndNLV: Bool?
	
	/**
	 
	 - parameter id: unique request id
	 - parameter accountName: account name to be observed
	 - parameter modelCode:
	 - parameter ledgerAndNLV: includes only currency positions as opposed to account values and currency positions
	 */
	
	public init(id: Int, accountName: String, modelCode:String? = nil, ledgerAndNLV: Bool? = false){
		self.id = id
		self.accountName = accountName
		self.modelCode = modelCode
		self.ledgerAndNLV = ledgerAndNLV
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return AccountUpdatesMultiCancel(id: id)
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(accountName)
		try container.encode(modelCode)
		try container.encode(ledgerAndNLV)
	}
}


public struct AccountUpdatesMultiCancel: IdentifiableRequest {
	
	private let version:Int = 1

	public let type: RequestType = .accountUpdatesMultiCancel
	
	private let minimumServerVersion: ServerVersion = .modelsSupport

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


//MARK: - RESPONSE


/**
 same as updateAccountValue{) except it can be for a certain
 account/model
 */
public struct AccountUpdateMulti<T>: AccountKeyValueUpdate, Identifiable where T: Decodable & Sendable {
	
	public typealias Key = AccountUpdateKeys

	public let id: Int

	/// The account identifier
	public let accountName: String

	/// updated account parameter
	public let key: Key

	/// updated parameter value
	public let value: T

	/// specifies currency, if the value is monetary unit
	public let currency: String?

	public let modelCode: String

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.modelCode = try container.decode(String.self)
		self.key = try container.decode(AccountUpdateKeys.self)
		self.value = try container.decode(T.self)
		self.currency =  try container.decodeOptional(String.self)
	}
	
}
	
/**
 same as accountDownloadEnd{) except it can be for a certain
 account/model
 */
public struct AccountUpdateMultiEnd: IBEvent, IBDecodable, Identifiable{

	public let id: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}
	
}
	


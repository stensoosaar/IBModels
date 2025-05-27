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
 Requests a specific account’s updates, specified by account keys.
 
 The initial invocation of `AccountSummaryRequest` will result in a list of all requested values being returned, and then every three minutes those values which have changed will be returned. The update frequency of 3 minutes and cannot be changed
 */
public struct AccountSummaryRequest: AnyCancellableRequest, IdentifiableRequest {
	
	private let version:Int = 1

	public let type: RequestType = .accountSummary
	
	private let minimumServerVersion: ServerVersion = .accountSummary

	/// A unique identifier for this request.
	public let id: Int
	
	/// Subscribed account parameters
	public let keys:[AccountSummaryKeys]
	
	/// account group to be subscribed
	public let group: String
	
	/**
	 Creates new request for account profit and loss updates
	 - returns: `AccountSummary` real time updates
	 - parameter id: Unique request id
	 - parameter keys: specifies account parameters to be subscribed
	 - parameter group: set to “All” to return account summary data for all accounts, or set to a specific Advisor Account Group name that has already been created in TWS Global Configuration.
	 */
	public init( id: Int, keys:[AccountSummaryKeys], group: String = "All"){
		self.id = id
		self.keys = keys
		self.group = group
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		AccountSummaryCancel(id: id)
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(group)
		try container.encode(keys.compactMap({$0.rawValue}).joined(separator: ","))
	}
}


/**
 Cancellation request for AccountSummaryRequest
 */
public struct AccountSummaryCancel: IdentifiableRequest {
	
	private let version:Int = 1

	public let type: RequestType = .accountSummaryCancel
	
	private let minimumServerVersion: ServerVersion = .accountSummary

	public let id: Int
	
	/**
	Initializes a cancellation request for a specific AccountPNL stream.
	- Parameter id: The identifier of the active `AccountSummaryRequest` to cancel.
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



/**
Delivers account key value updates
 */
public struct AccountSummary<T>: AccountKeyValueUpdate, Identifiable where T: Decodable & Sendable {
		
	public typealias Key = AccountSummaryKeys
	
	/// The identifier matching the original request.
	public let id: Int
	
	/// The account name for which to request updates.
	public let accountName: String
	
	/// updated account parameter name
	public let key: Key
	
	/// updated account parameter value
	public let value: T
	
	/// updated account parameter denomination
	public let currency: String?
		
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.key = try container.decode(AccountSummaryKeys.self)
		self.value = try container.decode(T.self)
		self.currency = try container.decodeOptional(String.self)
	}
	
}


/**
 This method is called once all account summary data for a given request are received.
 */
public struct AccountSummaryEnd:  IBEvent, IBDecodable, Identifiable{
	public let type: ResponseType = .accountSummaryEnd
	public let id: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}
	
}

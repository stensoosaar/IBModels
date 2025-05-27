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
 A request to subscribe to real-time profit and loss updates for a specific account and optional model.

 Sends an `AccountPNL` response stream that includes daily, realized, and unrealized PnL metrics.
 
 - note: Use `AccountPNLCancel` to stop receiving updates.
*/

public struct AccountPNLRequest: AnyCancellableRequest, IdentifiableRequest {
	
	/// The type of the request, used to identify it in the IB protocol.
	public let type: RequestType = .accountPnL
	
	private let minimumServerVersion: ServerVersion = .accountPNL
	
	/// A unique identifier for this request.
	public let id: Int
	
	/// The account name for which to request PnL updates.
	public let accountName: String
	
	/// Optional model code to restrict PnL updates to a specific model within the account.
	public let model: String?
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return AccountPNLCancel(id: id)
	}
	
	/**
	 Creates new request for account profit and loss updates
	 - returns: `AccountPNL` real time updates
	 - parameter id: Unique request id
	 - parameter accountName: Account for which to receive PnL updates
	 - parameter modelName: Specify to request PnL updates for a specific model.
	 */
	public init(id: Int, accountName: String, model: String? = nil){
		self.id = id
		self.accountName = accountName
		self.model = model
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(accountName)
		try container.encodeOptional(model)
	}
	
}

/**
 Cancellation request for AccountPNLRequest
 */
public struct AccountPNLCancel: AnyRequest, IdentifiableRequest {
	
	/// The type of the request.
	public let type: RequestType = .accountPnLCancel
	
	/// The minimum server version required to issue this cancellation.
	private let minimumServerVersion: ServerVersion = .accountPNL
	
	/// Request id to be cancelled
	public let id: Int
	
	/**
	Initializes a cancellation request for a specific AccountPNL stream.
	- Parameter id: The identifier of the active `AccountPNLRequest` to cancel.
	*/
	public init(id: Int){
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
	
}


/**
 A response containing real-time profit and loss (PnL) information for an account.
 */
public struct AccountPNL: IBEvent, IBDecodable, Identifiable {
	
	/// The identifier matching the original request.
	public let id: Int
	
	/// The current session's daily profit or loss for the account, in base currency.
	public let daily: Double
	
	/// The unrealized profit or loss from currently open positions, if available.
	public let unrealized: Double?

	/// The realized profit or loss from positions closed during the current session, if available.
	public let realized: Double?

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.daily = try container.decode(Double.self)
		if decoder.serverVersion >= .unrealizedPnl {
			self.unrealized = try container.decodeOptional(Double.self)
		} else {
			self.unrealized = nil
		}
		if decoder.serverVersion >= .realizedPnl {
			self.realized = try container.decodeOptional(Double.self)
		} else {
			self.realized = nil
		}
	}

}

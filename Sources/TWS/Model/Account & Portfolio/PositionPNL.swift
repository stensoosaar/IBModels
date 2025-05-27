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
 Requests position PNL data for specific contract at account
 
 Alternatives: `PositionsPNLMultiRequest` or `AccountUpdatesRequest`
 */
public struct PositionPNLRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .positionPnL
	
	private let minimumServerVersion: ServerVersion = .accountPNL
	
	/// A unique identifier for this request.
	public let id: Int

	/// The account name for which to request PnL updates.
	public let accountName: String
		
	/// The unique IB contract id
	public let contractId: Int

	///
	public let model: String?

	/**
	 Creates new request for position profit and loss updates
	 - returns: `PositionPNL` real time updates
	 - parameter id: Unique request id
	 - parameter accountName: Account for which to receive PnL updates
	 - parameter contractId: contract's IB id. Can be obtained via `ContractDetailsRequest`
	 - parameter modelName: Specify to request PnL updates for a specific model.
	 */
	public init(id: Int, accountName: String, contractId: Int, model: String? = nil){
		self.id = id
		self.accountName = accountName
		self.contractId = contractId
		self.model = model
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return PositionPNLCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(accountName)
		try container.encodeOptional(model)
		try container.encode(contractId)
	}
}


/**
 Cancellation request for PositionPnLRequest
 */
public struct PositionPNLCancel: IdentifiableRequest {
	
	public let type: RequestType = .positionPnLCancel

	private let minimumServerVersion: ServerVersion = .accountPNL

	/// Request id to be cancelled
	public let id: Int
	
	/**
	Initializes a cancellation request for a specific AccountPNL stream.
	- Parameter id: The identifier of the active `PositionPnLRequest` to cancel.
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
 Delivers position pnl data for requested contract
 
 As this message do not contain any contract / account references,
 original `PositionPnLRequest` request shall be stored and matched by id
 */
public struct PositionPNL: IBEvent, IBDecodable, Identifiable {
		
	/// The identifier matching the original request.
	public let id: Int
	
	/// how many contracts we have open
	public let units: Double
	
	/// profit or loss of the current position during the the current session
	public let daily: Double
	
	/// The unrealized profit or loss
	public let unrealized: Double
	
	/// The unrealized profit or loss, if position is reduced during the current session
	public let realized: Double?
	
	/// The current market value of the position
	public let marketValue: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		id = try container.decode(Int.self)
		units = try container.decode(Double.self)
		daily = try container.decode(Double.self)
		unrealized = try container.decode(Double.self)
		realized = try container.decodeOptional(Double.self)
		marketValue = try container.decode(Double.self)
	}
	
}
	

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



//MARK: - REQUEST

public struct ExecutionsRequest: IdentifiableRequest{
	
	public let type: RequestType = .executions

	private let version:Int = 3

	public let id: Int
	
	public struct Filter: IBEncodable, Sendable{
		public let clientId: Int?
		public let accountName: String?
		public let time: Date?
		public let symbol: String?
		public let type: Contract.SecuritiesType?
		public let exchange: String?
		public let side: Order.Action?
		
		public init(
			clientId: Int? = nil,
			accountName: String? = nil,
			time: Date? = nil,
			symbol: String? = nil,
			type: Contract.SecuritiesType? = nil,
			exchange: String? = nil,
			side: Order.Action? = nil
		) {
			self.clientId = clientId
			self.accountName = accountName
			self.time = time
			self.symbol = symbol
			self.type = type
			self.exchange = exchange
			self.side = side
		}
		
		public func encode(to encoder: IBEncoder) throws {
			var container = encoder.unkeyedContainer()
			try container.encodeOptional(clientId)
			try container.encodeOptional(accountName)
			encoder.dateEncodingStrategy = .defaultFormat
			try container.encodeOptional(time)
			try container.encodeOptional(symbol)
			try container.encodeOptional(type)
			try container.encodeOptional(exchange)
			try container.encodeOptional(side)
			
		}
		
	}
	
	public let filter: Filter?
	
	public init(id: Int, filter: Filter? = nil) {
		self.id = id
		self.filter = filter
	}
	
	public func encode(to encoder: IBEncoder) throws {
				
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
			
		if encoder.serverVersion >= .executionDataChain {
			try container.encode(id)
		}
			
		if encoder.serverVersion.rawValue >= 9 {
			try container.encodeOptional(filter)
		}
		
	}
}


//MARK: - RESPONSES


/**
 This event is fired when the reqExecutions{) functions is
 invoked, or when an order is filled.
 */
public struct Execution:  IBEvent, IBDecodable, Identifiable{
		
	public let id: Int
	
	public let contract: Contract
	
	/// The API client’s order Id. May not be unique to an account.
	public let orderId: Int
	
	///The API client identifier which placed the order which originated this execution.
	public let clientId: Int
	
	///The execution’s identifier. Each partial fill has a separate ExecId. A correction is indicated by an ExecId which differs from a previous ExecId in only the digits after the final period
	public let execId: String
	
	///The execution’s server time.
	public let time: String
	
	///The account to which the order was allocated.
	public let accountName: String
	
	///The exchange where the execution took place.
	public let exchange: String
	
	///Specifies if the transaction was buy or sale BOT for bought
	public let side: String
	
	///	The number of shares filled.
	public let shares: Double
	
	///The order’s execution price excluding commissions.
	public let price: Double
	
	///The TWS order identifier. The PermId can be 0 for trades originating outside IB.
	public let permId: Int
	
	///Identifies whether an execution occurred because of an IB-initiated liquidation.
	public let liquidation: Bool
	
	///Cumulative quantity. Used in regular trades
	public let cumQty: Double
	
	///Average price. Used in regular trades
	public let avgPrice: Double
	
	///	The OrderRef is a user-customizable string that can be set from the API or TWS and will be associated with an order for its lifetime.
	public let orderRef: String
	
	///The Economic Value Rule name and the respective optional argument. The two values should be separated by a colon.
	public let evRule: String?
	
	///Tells you approximately how much the market value of a contract would change if the price were to change by 1. It cannot be used to get market value by multiplying the price by the approximate multiplier.
	public let evMultiplier: Double?
	
	///model code
	public let modelCode: String?
	
	
	public enum Liquidity: Int, Sendable, Codable {
		case none = 0
		case added = 1
		case removed = 2
		case roudedOut = 3
	}
	
	///The liquidity type of the execution. Requires TWS 968+ and API v973.05+
	public let lastLiquidity: Liquidity?
	
	//pending price revision
	public let pendingPriceRevision: Bool?
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = decoder.serverVersion < .lastLiquidity ? try container.decode(Int.self) : decoder.serverVersion.rawValue
		self.id = version >= 7 ? try container.decode(Int.self) : -1
		self.orderId = try container.decode(Int.self)
		self.contract = try container.decode(Contract.self)
		
		self.execId = try container.decode(String.self)
		self.time = try container.decode(String.self)
		self.accountName = try container.decode(String.self)
		self.exchange = try container.decode(String.self)
		self.side = try container.decode(String.self)
		self.shares = try container.decode(Double.self)
		self.price = try container.decode(Double.self)
		self.permId = try container.decode(Int.self)
		self.clientId = try container.decode(Int.self)
		self.liquidation = try container.decode(Bool.self)
		
		self.cumQty = try container.decode(Double.self)
		self.avgPrice = try container.decode(Double.self)
		self.orderRef = try container.decode(String.self)
		
		self.evRule = version >= 9 ? try container.decodeOptional(String.self) : nil
		self.evMultiplier = version >= 9 ? try container.decodeOptional(Double.self) : nil

		self.modelCode = decoder.serverVersion > .modelsSupport ? try container.decodeOptional(String.self) : nil

		self.lastLiquidity = decoder.serverVersion > .lastLiquidity ? try container.decodeOptional(Liquidity.self) : nil
		self.pendingPriceRevision = decoder.serverVersion > .pendingPriceRevision ? try container.decodeOptional(Bool.self) : nil

	}
	
}



/**
 This function is called once all executions have been sent to
 a client in response to reqExecutions{).
 */
public struct ExecutionEnd:  IBEvent, IBDecodable, Identifiable{
	public let type: ResponseType = .executionDataEnd
	public let id: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}
	
}



/**
 The commissions and fees generated by an trade execution
 s triggered as follows:
 - immediately after a trade execution
 - by calling reqExecutions{).
 */
public struct CommissionReport:  IBEvent, IBDecodable{
	
	public let type: ResponseType = .commissionAndFeesReport

	/// the execution’s id this commission belongs to.
	public let execId: String
	
	/// the combined cost of commissions and fees.
	public let commissionAndFees: Double
	
	/// The currency denoting the value of the commissionAndFees.
	public let currency: String
	
	/// the realized profit and loss
	public let realizedPNL: Double?
	
	/// The income return.
	public let returnYield: Double?
	
	/// date expressed in yyyymmdd format.
	public let yieldRedemptionDate:	Date?
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.execId = try container.decode(String.self)
		self.commissionAndFees = try container.decode(Double.self)
		self.currency = try container.decode(String.self)
		self.realizedPNL = try container.decodeOptional(Double.self)
		self.returnYield = try container.decodeOptional(Double.self)
		decoder.dateDecodingStrategy = .eodPriceHistoryFormat
		yieldRedemptionDate = try container.decodeOptional(Date.self)

	}
	
}

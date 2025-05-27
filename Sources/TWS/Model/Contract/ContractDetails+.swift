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
 Requests all details for respective contract
 */
public struct ContractDetailsRequest: IdentifiableRequest{
	
	public let type: RequestType = .contractDetails
	
	private let version:Int = 8

	/// request id
	public let id: Int
	
	/// contract
	public let contract: Contract
	
	private let minimumServerVersion: Int = 4
	
	/**
	 Creates new request for quering contract details
	 
	 Number of responses will depend you well the contract object is specified.
	 
	 - returns: one or many ContractDetails object.
	 - parameter id: unique request id
	 - parameter contract: contract
	 */
	public init(id: Int, contract: Contract) {
		self.id = id
		self.contract = contract
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
			
		if encoder.serverVersion >= .contractDataChain {
			try container.encode(id)
		}
			
		try container.encode(contract.id ?? 0)
		try container.encodeOptional(contract.symbol)
		try container.encodeOptional(contract.type)
		try container.encodeOptional(contract.expiration)
		try container.encodeOptional(contract.strike)
		try container.encodeOptional(contract.right)
		try container.encodeOptional(contract.multiplier)
			
		if encoder.serverVersion >= .primaryExch {
			try container.encodeOptional(contract.exchange)
			try container.encodeOptional(contract.primaryExchange)
		} else if encoder.serverVersion >= .linking {
			let targetMarkets = ["BEST", "SMART"]
			if let primaryExch = contract.primaryExchange,
				let destination = contract.exchange,
				targetMarkets.contains(destination) == true {
					try container.encodeOptional("\(destination):\(primaryExch)")
			} else {
				try container.encodeOptional(contract.exchange)
			}
		}
			
		try container.encodeOptional(contract.currency)
		
		try container.encodeOptional(contract.localSymbol)
		
		if encoder.serverVersion >= .tradingClass {
			try container.encodeOptional(contract.tradingClass)
		}
		
		try container.encodeOptional(contract.includeExpired)
			
		if encoder.serverVersion >= .secIdType {
			try container.encodeOptional(contract.globalID?.type)
			try container.encodeOptional(contract.globalID?.identifier)
		}
		
		if encoder.serverVersion >= .bondIssuerid {
			try container.encodeOptional(contract.issuerId)
		}
			
	}
}



/**
Delivers contract
 */

public struct ContractDetailsMessage: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let details: ContractDetails
	
	public init(from decoder: IBDecoder) throws {

		var container = try decoder.unkeyedContainer()

		let version = decoder.serverVersion < .sizeRules ? try container.decode(Int.self) : 8
		
		id = version >= 3 ? try container.decode(Int.self) : -1
		
		var temp = ContractDetails()
		
		temp.symbol = try container.decodeOptional(String.self)
		temp.type = try container.decodeOptional(Contract.SecuritiesType.self)

		temp.expiration = try container.decodeOptional(DateComponents.self)

		if decoder.serverVersion >= .lastTradeDate {
			temp.lastTradeDate = try container.decodeOptional(Date.self)
		}
		
		temp.strike = try container.decodeOptional(Double.self)
		temp.right = try container.decodeOptional(Contract.ExecutionRight.self)
		temp.exchange = try container.decodeOptional(String.self)
		temp.currency = try container.decodeOptional(String.self)
		temp.localSymbol = try container.decodeOptional(String.self)
		temp.marketName = try container.decodeOptional(String.self)
		temp.tradingClass = try container.decodeOptional(String.self)
		temp.id = try container.decodeOptional(Int.self)
		temp.minTick = try container.decodeOptional(Double.self)
		
		
		if decoder.serverVersion >= .mdSizeMultiplier && decoder.serverVersion < .sizeRules {
			// mdSizeMultiplier - not used anymore
			_ = try container.decodeOptional(Int.self)
		}
		
		temp.multiplier = try container.decodeOptional(Double.self)
		let orderTypes = try container.decodeOptional(String.self)?.components(separatedBy: ",")
		temp.orderTypes = orderTypes?.compactMap({ OrderType(rawValue: $0)})

		temp.validExchanges = try container.decodeOptional(String.self)?.components(separatedBy: ",")

		if version >= 2 {
			temp.priceMagnifier = try container.decodeOptional(Int.self)
		}
		
		if version >= 4 {
			temp.underConid = try container.decodeOptional(Int.self)
		}

		if version >= 5 {
			temp.longName = try container.decodeOptional(String.self)
		   //contract.longName(decoder.serverVersion >= .ENCODE_MSG_ASCII7 ? decodeUnicodeEscapedString(readStr()) : readStr())
			temp.primaryExchange = try container.decodeOptional(String.self)
		}

		if version >= 6 {
			temp.contractMonth = try container.decodeOptional(String.self)
			temp.industry = try container.decodeOptional(String.self)
			temp.category = try container.decodeOptional(String.self)
			temp.subcategory = try container.decodeOptional(String.self)
			temp.tradingCalendar = try container.decodeOptional(TradingCalendar.self)
			
		 }

		if version >= 8 {
			temp.evRule = try container.decodeOptional(String.self)
			temp.evMultiplier = try container.decodeOptional(Double.self)
		}

		if version >= 7 {
			let count = try container.decode(Int.self)
			var buffer: [Contract.GlobalIdentifier] = []
			for _ in 0..<count {
				let temp = try container.decode(Contract.GlobalIdentifier.self)
				buffer.append(temp)
			}
			temp.secIdList = buffer
		}

		if decoder.serverVersion >= .aggGroup {
			temp.aggGroup = try container.decodeOptional(Int.self)
		}

		if decoder.serverVersion >= .underlyingInfo {
			temp.underSymbol = try container.decodeOptional(String.self)
			temp.underSecType = try container.decodeOptional(Contract.SecuritiesType.self)
		}

		if decoder.serverVersion >= .marketRules {
			let ruleIdentifiers = try container.decodeOptional(String.self)?.components(separatedBy: ",")
			if let markets = temp.validExchanges, let rules = ruleIdentifiers {
				temp.marketRuleIds = Dictionary(uniqueKeysWithValues: zip(markets, rules))
			}
		}

		if decoder.serverVersion >= .realExpirationDate {
			temp.realExpirationDate = try container.decodeOptional(Date.self)
		}

		if decoder.serverVersion >= .stockType {
			temp.stockType = try container.decodeOptional(String.self)
		}

		if decoder.serverVersion >= .fractionalSizeSupport && decoder.serverVersion < .sizeRules {
			 // sizeMinTick - not used anymore
			_ = try container.decodeOptional(Double.self)
		}

		if decoder.serverVersion >= .sizeRules {
			temp.minSize = try container.decodeOptional(Double.self)
			temp.sizeIncrement = try container.decodeOptional(Double.self)
			temp.suggestedSizeIncrement = try container.decodeOptional(Double.self)
		}
		if decoder.serverVersion >= .fundDataFields && temp.type == .fund {
			temp.fundName = try container.decodeOptional(String.self)
			temp.fundFamily = try container.decodeOptional(String.self)
			temp.fundType = try container.decodeOptional(String.self)
			temp.fundFrontLoad = try container.decodeOptional(String.self)
			temp.fundBackLoad = try container.decodeOptional(String.self)
			temp.fundBackLoadTimeInterval = try container.decodeOptional(String.self)
			temp.fundManagementFee = try container.decodeOptional(String.self)
			temp.fundClosed = try container.decodeOptional(Bool.self)
			temp.fundClosedForNewInvestors = try container.decodeOptional(Bool.self)
			temp.fundClosedForNewMoney = try container.decodeOptional(Bool.self)
			temp.fundNotifyAmount = try container.decodeOptional(String.self)
			temp.fundMinimumInitialPurchase = try container.decodeOptional(String.self)
			temp.fundSubsequentMinimumPurchase = try container.decodeOptional(String.self)
			temp.fundBlueSkyStates = try container.decodeOptional(String.self)
			temp.fundBlueSkyTerritories = try container.decodeOptional(String.self)
			temp.fundDistributionPolicy = try container.decodeOptional(ContractDetails.FundDistributionPolicy.self)
			temp.fundAssetType = try container.decodeOptional(ContractDetails.FundAssetType.self)
		}
		
		if decoder.serverVersion >= .ineligibilityReasons {
			let reasonCount = try container.decode(Int.self)
			var buffer: [ContractDetails.IneligibilityReason] = []
			for _ in 0..<reasonCount {
				let reason = try container.decode(ContractDetails.IneligibilityReason.self)
				buffer.append(reason)
			}
			temp.ineligibilityReasons = buffer
		}
		
		self.details = temp
		
	}
	
}

/**
 This function is called once all contract details for a given
 request are received. This helps to public structine the end of an option
 chain.
 */
public struct ContractDetailsEndMessage: IBEvent, IBDecodable, Identifiable{
	public let type: ResponseType = .contractDataEnd
	public let id: Int
	
	public init(from decoder:  IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}
	
}

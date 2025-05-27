//
//  ContractNews.swift
//  IBModels
//
//  Created by Sten Soosaar on 25.05.2025.
//

import Foundation


public struct BroadTapeNews: IdentifiableRequest, AnyCancellableRequest {
	
	public let type: RequestType = .marketData
	private let version:Int = 11
	public let id: Int
	public let contract: Contract
	public let eventType = "mdoff,292"
	private let snapshot: Bool = false
	private let regulatorySnapshot:Bool = false
	private let options:[String:String]? = nil

	
	public init(id: Int, newsProvider:String) {
		self.id = id
		var newsContract = Contract()
		newsContract.symbol = String(format: "%@:%@_ALL", newsProvider, newsProvider)
		newsContract.type = .news
		newsContract.exchange = newsProvider
		contract = newsContract
	}
	
	public var cancel: any AnyRequest{
		return MarketDataCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
		
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		
		if encoder.serverVersion >= .reqMktDataConid {
			try container.encodeOptional(contract.id)
		}
		
		try container.encodeOptional(contract.symbol)
		try container.encodeOptional(contract.type)
		try container.encodeOptional(contract.expiration)
		try container.encodeOptional(contract.strike)
		try container.encodeOptional(contract.right)
		
		if encoder.serverVersion.rawValue >= 15 {
			try container.encodeOptional(contract.multiplier)
		}
		
		try container.encodeOptional(contract.exchange)
		
		if encoder.serverVersion.rawValue >= 14 {
			try container.encodeOptional(contract.primaryExchange)
		}
		
		try container.encodeOptional(contract.currency)
		
		if encoder.serverVersion.rawValue >= 2 {
			try container.encodeOptional(contract.localSymbol)
		}
		
		if encoder.serverVersion >= .tradingClass {
			try container.encodeOptional(contract.tradingClass)
		}
		
		if contract.type == .combo {
			try container.encode(contract.comboLegs?.count ?? 0)
			if let legs = contract.comboLegs{
				for leg in legs {
					try container.encodeOptional(leg.id)
					try container.encodeOptional(leg.ratio)
					try container.encodeOptional(leg.action)
					try container.encodeOptional(leg.exchange)
				}
			}
		}
		
		if encoder.serverVersion >= .deltaNeutral {
			if let temp = contract.deltaNeutralContract {
				try container.encodeOptional(true)
				try container.encodeOptional(temp.id)
				try container.encodeOptional(temp.delta)
				try container.encodeOptional(temp.price)
			} else {
				try container.encodeOptional(false)
			}
		}
		
		if encoder.serverVersion.rawValue >= 31 {
			try container.encodeOptional(eventType)
		}
		
		if encoder.serverVersion >= .snapshotMktData {
			try container.encode(snapshot)
		}
		
		if encoder.serverVersion >= .reqSmartComponents {
			try container.encode(regulatorySnapshot)
		}
		
		// send mktDataOptions parameter
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
		
	}
	
}

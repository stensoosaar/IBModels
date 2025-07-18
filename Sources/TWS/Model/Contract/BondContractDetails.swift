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
 Delivers bond contract details
 */
public struct BondDetailsMessage: IBEvent, IBDecodable, Identifiable {
	
	/// id of the originating request
	public let id: Int
	
	/// requested details
	public let details: ContractDetails

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()

		let version = decoder.serverVersion > .sizeRules
		? try container.decode(Int.self) : 6
		
		self.id = version >= 3 ? -1 : try container.decode(Int.self)

		var temp = ContractDetails()
		
		temp.symbol = try container.decode(String.self)
		temp.type = try container.decode(SecuritiesType.self)
		temp.cusip = try container.decode(String.self)
		temp.coupon = try container.decode(Double.self)
		temp.expiration = try container.decode(DateComponents.self)
		temp.issueDate = try container.decode(String.self)
		temp.ratings = try container.decode(String.self)
		temp.bondType = try container.decode(String.self)
		temp.couponType = try container.decode(String.self)
		temp.convertible = try container.decode(Bool.self)
		temp.callable = try container.decode(Bool.self)
		temp.putable = try container.decode(Bool.self)
		temp.descAppend = try container.decode(String.self)
		temp.exchange = try container.decode(String.self)
		temp.currency = try container.decode(String.self)
		temp.marketName = try container.decode(String.self)
		temp.tradingClass = try container.decode(String.self)
		temp.id = try container.decode(Int.self)
		temp.minTick = try container.decode(Double.self)
		
		if decoder.serverVersion >= .mdSizeMultiplier && decoder.serverVersion < .sizeRules {
			_ = try container.decode(Int.self)
		}

		let orderTypes = try container.decodeOptional(String.self)?.components(separatedBy: ",")
		temp.orderTypes = orderTypes?.compactMap({ OrderType(rawValue: $0)})
		
		temp.validExchanges = try container.decodeOptional(String.self)?.components(separatedBy: ",")

		
		if version >= 2 {
			temp.nextOptionDate = try container.decode(String.self)
			temp.nextOptionType = try container.decode(String.self)
			temp.nextOptionPartial = try container.decode(Bool.self)
			temp.notes = try container.decode(String.self)
		}
		if version >= 4 {
			temp.longName = try container.decode(String.self)
		}
		
		if decoder.serverVersion >= .bondTradingHours {
			temp.tradingCalendar = try container.decodeOptional(TradingCalendar.self)
		}
		if version >= 6 {
			temp.evRule = try container.decode(String.self)
			temp.evMultiplier = try container.decode(Double.self)
		}
		if version >= 5 {
			let count = try container.decode(Int.self)
			var buffer:[GlobalIdentifier] = []
			for _ in 0 ..< count {
				let temp = try container.decode(GlobalIdentifier.self)
				buffer.append(temp)
			}
			temp.secIdList = buffer
		}
		
		if decoder.serverVersion >= .aggGroup {
			temp.aggGroup = try container.decode(Int.self)
		}
		
		if decoder.serverVersion >= .marketRules{
			let ruleIdentifiers = try container.decodeOptional(String.self)?.components(separatedBy: ",")
			if let markets = temp.validExchanges, let rules = ruleIdentifiers {
				temp.marketRuleIds = Dictionary(uniqueKeysWithValues: zip(markets, rules))
			}		}
		
		if decoder.serverVersion >= .sizeRules {
			temp.minSize = try container.decode(Double.self)
			temp.sizeIncrement = try container.decode(Double.self)
			temp.suggestedSizeIncrement = try container.decode(Double.self)
		}

		self.details = temp
		
	}
	
}

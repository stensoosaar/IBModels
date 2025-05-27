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



								  
public struct MarketRuleRequest: AnyRequest{
	
	public let type: RequestType = .marketRule
	
	private let minimumServerVersion: ServerVersion = .marketRules
	
	public let marketRuleId: Int
	
	public init(marketRuleId: Int) {
		self.marketRuleId = marketRuleId
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(marketRuleId)
	}
}



/**
 returns minimum price increment public structure for a particular market rule ID
 */
public struct MarketRule:  IBEvent, IBDecodable{

	public let marketRuleId: Int
	
	public struct PriceIncrement: Sendable, Decodable{
		public var lowerBound: Double
		public var increment: Double

		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.lowerBound = try container.decode(Double.self)
			self.increment = try container.decode(Double.self)
		}

	}

	public let priceIncrements: [PriceIncrement]
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.marketRuleId = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		var buffer: [PriceIncrement] = []
		for _ in 0..<count{
			let temp = try container.decode(PriceIncrement.self)
			buffer.append(temp)
		}
		priceIncrements = buffer
	}
}

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
 Requests venues for which market data is returned 
 */
public struct MarketDepthExchangeRequest: AnyRequest{
	
	public let type: RequestType = .marketDepthExchanges
	
	/**
	 Creates new request to check which exchanges offer deep book data
	 - returns: ´MarketDepthExchanges´
	 */
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
	}
	
}



/**
 returns array of exchanges which return depth to UpdateMktDepthL2
 */
public struct MarketDepthExchanges: IBEvent, IBDecodable {
	
	public struct Provider: Sendable, IBDecodable {
		public let name: String
		public let type: Contract.SecuritiesType
		public let listingExch: String?
		public let serviceDataType: String?
		public let aggGroup: Int?
		
		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.name = try container.decode(String.self)
			self.type = try container.decode(Contract.SecuritiesType.self)
			if decoder.serverVersion >= .serviceDataType{
				self.listingExch =  try container.decodeOptional(String.self)
				self.serviceDataType = try container.decodeOptional(String.self)
				self.aggGroup = try container.decodeOptional(Int.self)
			} else{
				self.listingExch =  try container.decodeOptional(String.self)
				let test = try container.decodeOptional(Bool.self)
				self.serviceDataType = test == true ? "Deep2" : "Deep"
				self.aggGroup = nil
			}
			
		}
		
	}
		
	public let exchanges: [Provider]
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		let count = try container.decode(Int.self)
		var buffer: [Provider] = []
		
		for _ in 0 ..< count {
			let temp = try container.decode(MarketDepthExchanges.Provider.self)
			buffer.append(temp)
		}
		
		exchanges = buffer
		
	}
	
}

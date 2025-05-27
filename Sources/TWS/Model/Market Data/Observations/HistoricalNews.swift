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




public struct HistoricalNewsRequest: IdentifiableRequest{
	
	public let type: RequestType = .historicalNews
	
	private let minimumServerVersion: ServerVersion = .reqHistoricalNews
	
	public let id: Int
	
	public let contractId: Int
	
	public let providerCodes: String
	
	public let interval: DateInterval
	
	public let totalResults: Int
	
	public let historicalNewsOptions: [String:String]?
	
	public init(
		id: Int,
		contractId: Int,
		providerCodes: String,
		interval: DateInterval,
		totalResults: Int,
		historicalNewsOptions: [String:String]? = nil
	){
		self.id = id
		self.contractId = contractId
		self.providerCodes = providerCodes
		self.interval = interval
		self.totalResults = totalResults
		self.historicalNewsOptions = historicalNewsOptions
		
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contractId)
		try container.encode(providerCodes)
		try container.encode(interval.start)
		try container.encode(interval.end)
		try container.encode(totalResults)
		
		if encoder.serverVersion >= .newsQueryOrigins {
			try container.encodeOptional(historicalNewsOptions)
		}
	}
	
}


/*
returns historical news headlines
*/
public struct HistoricalNews: IBEvent, IBDecodable, Identifiable{
		
	public let id: Int
	
	public let time: Date
	
	public let provider: String
	
	public let articleId: String
	
	public let headline: String
	
	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.time = try container.decode(Date.self)
		self.provider = try container.decode(String.self)
		self.articleId = try container.decode(String.self)
		self.headline = try container.decode(String.self)
	}
	
}

/**
signals end of historical news
*/
public struct HistoricalNewsEnd: IBEvent, IBDecodable, Identifiable {

	public let id: Int

	public let hasMore: Bool
	
	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.hasMore = try container.decode(Bool.self)
	}

}



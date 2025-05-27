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
 Request to match contracts for search text
 - returns: `MatchingSymbols` object
 */
public struct MatchingSymbolsRequest: IdentifiableRequest {
	
	public let type: RequestType = .matchingSymbols
	
	private let minimumServerVersion: ServerVersion = .reqMatchingSymbols

	public let id: Int
	
	public let text: String
	
	/**
	 Creates new request to search contracts and available types matching search string.
	 - parameter id: request id
	 - parameter text: ticker or name
	 - note: for stocks only
	 */
	public init(id: Int, nameOrSymbol text:String){
		self.id = id
		self.text = text
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(text)
	}
}



/**
 Returns array of sample contract descriptions
 */
public struct MatchingSymbols: IBEvent, Identifiable {
	
	public struct SearchResult: Sendable, Decodable{
		public var contract: Contract
		public var availableTypes: [Contract.SecuritiesType]
	}
	
	public let id: Int
	public let results: [SearchResult]
	
}

extension MatchingSymbols: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		var buffer:[SearchResult] = []
		for _ in 0..<count{
			var contract = Contract()
			contract.id = try container.decode(Int.self)
			contract.symbol = try container.decode(String.self)
			contract.type = try container.decode(Contract.SecuritiesType.self)
			contract.primaryExchange = try container.decode(String.self)
			contract.currency = try container.decode(String.self)
			
			var derivates: [Contract.SecuritiesType] = []
			let derivateCount = try container.decode(Int.self)
			for _ in 0..<derivateCount{
				derivates.append(try container.decode(Contract.SecuritiesType.self))
			}
			
			if decoder.serverVersion >= .bondIssuerid{
				contract.description = try container.decodeOptional(String.self)
				contract.issuerId = try container.decodeOptional(String.self)
			}
			
			buffer.append(
				SearchResult(contract: contract, availableTypes: derivates)
			)
			
		}
		self.results = buffer
	}

}

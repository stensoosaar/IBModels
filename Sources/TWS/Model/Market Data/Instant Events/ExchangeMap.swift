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
 Requests exchange names for abbreviations used on quote level updates
 
 Different IB contracts have a different exchange map containing the set of exchanges on which they trade. Each exchange map has a different code, such as "a6" or "a9". This exchange mapping code is returned to `ExchangeMap` immediately after a market data request is made by a user with market data subscriptions.
 
 
 - note: only available when exchange is open
 */
public struct ExchangeMapRequest: IdentifiableRequest {
	
	public let type: RequestType = .smartComponents
	
	private let minimumServerVersion: ServerVersion = .reqSmartComponents

	public let id: Int
	
	public let bboExchange: String
	
	public init(id: Int, bboExchange: String){
		self.id = id
		self.bboExchange = bboExchange
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(bboExchange)
	}
}


/**
 Represents exchange component mapping for quote data
*/
public struct ExchangeMap: IBEvent, IBDecodable, Identifiable {

	public let id: Int
	
	public struct Exchange: Sendable, Codable{
		public let name: String
		public let code: String
		
		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.name = try container.decode(String.self)
			self.code = try container.decode(String.self)
		}

	}
	
	public let components: [Exchange]
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		var buffer: [Exchange] = []
		for _ in 0..<count{
			let index = try container.decode(Int.self)
			let exchange = try container.decode(Exchange.self)
			buffer[index] = exchange
		}
		self.components = buffer
	}
	
}

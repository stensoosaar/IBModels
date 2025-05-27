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
 A container for storing Soft Dollar Tier information.
*/

public struct SoftDollarTier: Decodable, Sendable{
	
	public let name: String
	public let value: String
	public let description: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.name = try container.decode(String.self)
		//print("SoftDollarTier.name", name)
		self.value = try container.decode(String.self)
		//print("SoftDollarTier.value", value)
		self.description = try container.decode(String.self)
		//print("SoftDollarTier.description", description)
	}
	
}




public struct SoftDollarTiersRequest: IdentifiableRequest { 

	public let type: RequestType = .softDollarTiers
	
	private let minimumServerVersion: ServerVersion = .softDollarTier

	public let id: Int

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
 Called when receives Soft Dollar Tier configuration information

 reqId - The request ID used in the call to EEClient::reqSoftDollarTiers
 tiers - Stores a list of SoftDollarTier that contains all Soft Dollar Tiers information
 */
public struct SoftDollarTiers:  IBEvent, IBDecodable, Identifiable {

	public let id: Int

	public let tiers: [SoftDollarTier]
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		var buffer:[SoftDollarTier] = []
		for _ in 0..<count{
			buffer.append(try container.decode(SoftDollarTier.self))
		}
		tiers = buffer
	}
	
}

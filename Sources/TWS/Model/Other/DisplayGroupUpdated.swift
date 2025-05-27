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





public struct DisplayGroupUpdateRequest: IdentifiableRequest {
	
	private let version:Int = 1

	public let type: RequestType = .updateDisplayGroup
	
	private let minimumServerVersion: ServerVersion = .linking

	public let id: Int

	public let contractInfo: String
	
	public init(id: Int, contractInfo: String){
		self.id = id
		self.contractInfo = contractInfo
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(contractInfo)
	}
}




/**
 This is sent by TWS to the API client once after receiving
 the subscription request subscribeToGroupEvents{), and will be sent
 again if the selected contract in the subscribed display group has
 changed.

 requestId - The requestId specified in subscribeToGroupEvents{).
 contractInfo - The encoded value that uniquely represents the contract
	 in IB. Possible values include:
	 none = empty selection
	 contractID@exchange = any non-combination contract.
		 Examples: 8314@SMART for IBM SMART; 8314@ARCA for IBM @ARCA.
	 combo = if any combo is selected.
 
 */
public struct DisplayGroupUpdate:  IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let contractInfo: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.contractInfo = try container.decode(String.self)
	}
	
}



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
 A request to subscribe open position size updates for all accounts / predefined model
 
 Initially all positions are returned, and then updates are returned for any position changes in real time.
 */
public struct PositionSizeMultiRequest: AnyCancellableRequest, IdentifiableRequest {
	
	private let version: Int = 1

	public let type: RequestType = .positionSizeMulti
	
	private let minimumServerVersion: ServerVersion = .modelsSupport

	public let id: Int

	public let accountName: String
	
	public let modelCode: String?
	
	/**
	 Creates new request to subscribe position size updates for specified account / model
	 - parameter id: unique request id
	 - paremeter accountName: account name to be subscriberd
	 - modelCode: predefined model
	 */
	public init(id: Int, accountName: String,  modelCode: String?=nil){
		self.id = id
		self.accountName = accountName
		self.modelCode = modelCode
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		PositionSizeMultiCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(accountName)
		try container.encodeOptional(modelCode)
	}
}


public struct PositionSizeMultiCancel: IdentifiableRequest{
	
	private let version:Int = 1

	public let type: RequestType = .positionSizeMultiCancel
	
	private let minimumServerVersion: ServerVersion = .modelsSupport

	public let id: Int

	/**
	 Creates cancellation request for outstanding PositionSizeMultiRequest
	 - parameter id: id of the request, to be cancelled.
	 - note: alternatively use request.cancel
	 */
	public init(id: Int) {
		self.id = id
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
}





/**
 Delivers real-time positions for all accounts or predefined model
 */
public struct PositionSizeMulti: IBEvent, IBDecodable, Identifiable {

	/// id, matching originating request
	public let id: Int

	/// account name position is held with
	public let accountName: String

	/// underlying contract
	public let contract: Contract

	/// number of contracts held
	public let units: Double

	/// price per contract.
	public let unitPrice: Double

	/// predefined model code
	public let modelCode: String?
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.contract = try container.decode(Contract.self)
		self.units = try container.decode(Double.self)
		self.unitPrice = try container.decode(Double.self) / (contract.multiplier ?? 1)
		self.modelCode = try container.decodeOptional(String.self)
	}
	
}

/**
 Indicates that all positions are delivered. 
 */
public struct PositionSizeMultiEnd: IBEvent, IBDecodable, Identifiable {

	/// id, matching originating request
	public let id: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}
	
}

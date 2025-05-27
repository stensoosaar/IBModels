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
 A request to subscribe open position size updates for all accounts
 
 Initially all positions are returned, and then updates are returned for any position changes in real time.
 */
public struct PositionSizeRequest: AnyCancellableRequest {
	
	public let type: RequestType = .positionSize

	private let version: Int = 1

	private let minimumServerVersion: ServerVersion = .accountSummary

	/**
	 Creates new request to subscribe position size updates for all accounts
	 - returns: stream of `PositionSize` events
	 */
	public init(){}

	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return PositionSizeCancel()
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
}


/**
 
 */
public struct PositionSizeCancel: AnyRequest {
	
	private let version: Int = 1

	public let type: RequestType = .positionSizeCancel
	
	private let minimumServerVersion: ServerVersion = .accountSummary

	/// Creates cancellation request for outstanding PositionSizeRequest
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
}



/**
 Delivers real-time open position size in specified account
 */
public struct PositionSize: IBEvent, IBDecodable{

	/// account name position is held with
	public let accountName: String

	/// underlying contract
	public let contract: Contract

	/// number of contracts held
	public let units: Double

	/// price per contract.
	public let unitPrice: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.contract = try container.decode(Contract.self)
		self.units = try container.decode(Double.self)
		self.unitPrice = try container.decode(Double.self) / (contract.multiplier ?? 1)
	}
	
}


/**
 This is called once all position data for a given request are
received and functions as an end marker for the position{) data.
*/
public struct PositionSizeEnd: IBEvent, IBDecodable{
	
   public let type: ResponseType = .positionSizeEnd
   
	public init(from decoder: IBDecoder) throws {
	   var container = try decoder.unkeyedContainer()
	   _ = try container.decode(Int.self)
   }
   
}

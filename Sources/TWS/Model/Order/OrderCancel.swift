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



public struct OrderCancel: Encodable, Sendable {
	public var manualOrderCancelTime: String
	public var extOperator: String
	public var manualOrderIndicator: Int

}


public struct CancelOrderRequest: IdentifiableRequest {
	
	public let type: RequestType = .orderCancel

	private let version:Int = 1
	
	private let minimumServerVersion: ServerVersion = .manualOrderTime
	
	public let id: Int
	
	public let orderCancel: OrderCancel
	

	public init (id: Int, orderCancel: OrderCancel) {
		self.id = id
		self.orderCancel = orderCancel
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		if encoder.serverVersion < .cmeTaggingFields {
			try container.encode(version)
		}
		try container.encode(id)
			
		if encoder.serverVersion >= .manualOrderTime {
			try container.encode(orderCancel.manualOrderCancelTime)
		}
			
		if encoder.serverVersion >= .rfqFields && encoder.serverVersion < .undoRfqFields {
			try container.encodeNil()
			try container.encodeNil()
			try container.encode(Int.max)
		}
			
		if encoder.serverVersion >= .cmeTaggingFields {
			try container.encode(orderCancel.extOperator)
			try container.encode(orderCancel.manualOrderIndicator)
		}
		
	}
}


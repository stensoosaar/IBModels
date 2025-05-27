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
 This event is called whenever the status of an order changes or on re/connecting to TWS if the client has any open orders
 */
public struct OrderStatus:  IBEvent, IBDecodable, Identifiable {
		
	/// The order ID that was specified previously in the call to placeOrder{)
	public let id: Int
	
	///The order status.
	public let status: OrderState.Status
	
	///Specifies the number of shares that have been executed.
	public let filled: Double
	
	///Specifies the number of shares still outstanding.
	public let remaining: Double
	
	///The average price of the shares that have been executed. This parameter is valid only if the filled parameter value is greater than zero. Otherwise, the price parameter will be zero.
	public let avgFillPrice: Double
	
	/// The TWS id used to identify orders. Remains the same over TWS sessions.
	public let permId: Int
	
	///The order ID of the parent order, used for bracket and auto trailing stop orders.
	public let parentId: Int
	
	// /The last price of the shares that have been executed. This parameter is valid only if the filled parameter value is greater than zero. Otherwise, the price parameter will be zero.
	public let lastFillPrice: Double
	
	///The ID of the client {or TWS) that placed the order. Note that TWS orders have a fixed clientId and orderId of 0 that distinguishes them from API orders.
	public let clientId: Int
	
	///This field is used to identify an order held when TWS is trying to locate shares for a short sell. The value used to indicate this is 'locate'.
	public let whyHeld: String?
	
	public let mktCapPrice: Double?
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = decoder.serverVersion > .marketCapPrice ? Int.max : try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.status = try container.decode(OrderState.Status.self)
		self.filled = try container.decode(Double.self)
		self.remaining = try container.decode(Double.self)
		self.avgFillPrice = try container.decode(Double.self)
		self.permId = try container.decode(Int.self)
		self.parentId = try container.decode(Int.self)
		self.lastFillPrice = try container.decode(Double.self)
		self.clientId = try container.decode(Int.self)

		self.whyHeld = version >= 6 ? try container.decodeOptional(String.self) : nil
		self.mktCapPrice = decoder.serverVersion >= .marketCapPrice ? try container.decodeOptional(Double.self) : nil
	}
	
}
	

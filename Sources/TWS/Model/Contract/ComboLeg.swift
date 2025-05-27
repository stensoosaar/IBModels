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
 Representing a leg within combo / spread orders.
 */

public struct ComboLeg: Codable, Sendable, Identifiable {
	/**
	 The Contract’s IB’s unique id.
	 */
	public var id: Int
	
	/**
	 Select the relative number of contracts for the leg you are constructing. To help determine the ratio for a specific combination order
	 */
	public var ratio: Int
	
	/**
	 The side (buy or sell) of the leg:
	 For individual accounts, only BUY and SELL are available. SSHORT is for institutions.
	 */
	public var action: Order.Action
	
	/**
	 The destination exchange to which the order will be routed.
	 */
	public var exchange: String
	
	public enum OpenClose: Int, Codable, Sendable{
		
		///Same as the parent security. This is the only option for retail customers.
		case same = 0
		
		///This value is only valid for institutional customers.
		case open = 1
		
		/// This value is only valid for institutional customers.
		case close = 2
		
		/// Unknown
		case unknown = 3
		
	}
	
	/**
	 For stock legs when doing short selling.
	 */
	public var openClose: Int?
	
	public enum ShortSaleSlot: Int, Codable, Sendable{
		
		case clearingBroker = 1
		
		case thirdParty = 2
		
	}
	
	/**
	 For stock legs when doing short selling.
	 */
	public var shortSaleSlot: Int?
	
	/**
	 When ShortSaleSlot is 2, this field shall contain the designated location.
	 */
	public var designatedLocation: String?
	
	public enum ExemptCode: Int, Codable, Sendable{
	
		case none = 0
		
		case uptickRule = -1
	}
	
	/**
	 Mark order as exempt from short sale uptick rule.
	 */
	public var exemptCode:ExemptCode = .uptickRule
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		//print("comboleg.id",id)
		self.ratio = try container.decode(Int.self)
		//print("comboleg.ratio",ratio)
		self.action = try container.decode(Order.Action.self)
		//print("comboleg.action",action)
		self.exchange = try container.decode(String.self)
		//print("comboleg.exchange",exchange)
		self.openClose = try container.decodeOptional(Int.self)
		//print("comboleg.openClose",openClose)
		self.shortSaleSlot = try container.decodeOptional(Int.self)
		//print("comboleg.shortSaleSlot",shortSaleSlot)
		self.designatedLocation = try container.decodeOptional(String.self)
		//print("comboleg.designatedLocation",designatedLocation)
		self.exemptCode = try container.decode(ComboLeg.ExemptCode.self)
		//print("comboleg.exemptCode",exemptCode)
	}
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(self.id)
		try container.encode(self.ratio)
		try container.encode(self.action)
		try container.encode(self.exchange)
		try container.encodeOptional(self.openClose)
		try container.encodeOptional(self.shortSaleSlot)
		try container.encodeOptional(self.designatedLocation)
		try container.encode(self.exemptCode)
	}
	
}


//
//  OrderAllocation.swift
//  
//
//  Created by Sten Soosaar on 01.05.2025.
//

import Foundation

/**
 The OrderAllocation class to denote an advisor’s allocations while trading subaccounts.
 */
public struct OrderAllocation: Decodable, Sendable {
	
	/// References the Account ID, i.e. U1234567, being allocated to.
	public let accountName: String
	
	/// References the current position of the account being allocated to.
	public let position: Double
	
	/// States the full position increase intended by the current trade.
	public let positionDesired: Double
	
	/// References the increase to position from the current trade. Unless the order is partially filled, this should reflect the PositionDesired value.
	public let positionAfter: Double
	
	/// Reference the quantity to increase by based on allocation.
	public let desiredAllocQty: Double
	
	/// References the maximum allowed quantity increase.
	public let allowedAllocQty: Double
	
	/// Denotes whether the order is a monetary allocation (true) or whole share allocation (false).
	public let isMonetary: Bool
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		
		self.accountName = try container.decode(String.self)
		//print("accountName",accountName)
		self.position = try container.decode(Double.self)
		//print("position",position)
		self.positionDesired = try container.decode(Double.self)
		//print("positionDesired",positionDesired)
		self.positionAfter = try container.decode(Double.self)
		//print("positionAfter",positionAfter)
		self.desiredAllocQty = try container.decode(Double.self)
		//print("desiredAllocQty",desiredAllocQty)
		self.allowedAllocQty = try container.decode(Double.self)
		//print("allowedAllocQty",allowedAllocQty)
		self.isMonetary = try container.decode(Bool.self)
		//print("isMonetary",isMonetary)
	}
	
	
	
	
	
}

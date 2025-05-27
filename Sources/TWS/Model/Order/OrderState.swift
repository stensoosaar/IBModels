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
 Provides an active order’s current state.
 */
public struct OrderState: Decodable, Sendable{
	
		
	public enum Status: String, Decodable, Sendable {
		
		case apiPending = "ApiPending"
				
		case apiCancelled = "ApiCancelled"
		
		/**
		 indicates that a simulated order type has been accepted by the IB system and that this order has yet to be elected. The order is held in the IB system until the election criteria are met. At that time the order is transmitted to the order destination as specified.
		 */
		case preSubmitted = "PreSubmitted"
		
		/**
		 indicates that you have sent a request to cancel the order but have not yet received cancel confirmation
		 from the order destination. At this point, your order is not confirmed canceled.
		 It is not guaranteed that the cancellation will be successful.
		 */
		case pendingCancel = "PendingCancel"
		
		///indicates that the balance of your order has been confirmed canceled by the IB system. This could occur unexpectedly when IB or the destination has rejected your order.
		case cancelled = "Cancelled"
		
		///indicates that your order has been accepted by the system.
		case submitted = "Submitted"
		
		///indicates that the order has been completely filled. Market orders executions will not always trigger a Filled status.
		case filled = "Filled"
		
		///indicates that the order was received by the system but is no longer active because it was rejected or canceled.
		case inactive = "Inactive"
		
		///indicates that you have transmitted the order, but have not yet received confirmation that it has been accepted by the order destination.
		case pendingSubmit = "PendingSubmit"
		
	}
	
	///The order’s current status.
	public var status: Status? = nil
	
	///The account’s current initial margin.
	public var initialMarginBefore: Double? = nil
	
	///The account’s current maintenance margin.
	public var maintenanceMarginBefore: Double? = nil
	
	///The account’s current equity with loan.
	public var equityWithLoanBefore: Double? = nil
	
	///The change of the account’s initial margin.
	public var initialMarginChange: Double? = nil
	
	///The change of the account’s maintenance margin.
	public var maintenanceMarginChange: Double? = nil
	
	///The change of the account’s equity with loan.
	public var equityWithLoanChange: Double? = nil
	
	///The order’s impact on the account’s initial margin.
	public var initialMarginAfter: Double? = nil
	
	///The order’s impact on the account’s maintenance margin.
	public var maintenanceMarginAfter: Double? = nil
	
	///Shows the impact the order would have on the account’s equity with loan.
	public var equityWithLoanAfter: Double? = nil
	
	///The account’s expected initial margin outside of regular trading hours.
	public var initialMarginBeforeOutsideRTH: Double? = nil
	
	///The account’s expected maintenance margin outside of regular trading hours.
	public var maintenanceMarginBeforeOutsideRTH: Double? = nil
	
	///The account’s expected equity with loan outside of regular trading hours.
	public var equityWithLoanBeforeOutsideRTH: Double? = nil
	
	///The expected change of the account’s initial margin outside of regular trading hours.
	public var initialMarginChangeOutsideRTH: Double? = nil
	
	///The expected change of the account’s maintenance margin outside of regular trading hours.
	public var maintenanceMarginChangeOutsideRTH: Double? = nil
	
	///The expected change of the account’s equity with loan outside of regular trading hours.
	public var equityWithLoanChangeOutsideRTH: Double? = nil
	
	///The order’s expected impact on the account’s initial margin outside of regular trading hours.
	public var initialMarginAfterOutsideRTH: Double? = nil
	
	///The order’s expected impact on the account’s maintenance margin outside of regular trading hours.
	public var maintenanceMarginAfterOutsideRTH: Double? = nil
	
	///Shows the expected impact the order would have on the account’s equity with loan outside of regular trading hours.
	public var equityWithLoanAfterOutsideRTH: Double? = nil
	
	///The order’s generated commission.
	public var commission: Double? = nil
	
	///The execution’s minimum commission.
	public var minCommission: Double? = nil
	
	///The executions maximum commission.
	public var maxCommission: Double? = nil
	
	///The generated commission currency.
	public var commissionCurrency: String? = nil

	///The margin currency.
	public var marginCurrency: String? = nil
	
	public var suggestedSize: Double? = nil

	public var rejectReason: String? = nil
	
	public var allocations: [OrderAllocation]? = nil
	
	///If the order is warranted, a descriptive message will be provided.
	public var warning: String? = nil
	
	public var completedTime: String? = nil
	
	public var completedStatus: String? = nil
	
	internal init(){}
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		self.status = try container.decode(Status.self)
		//print("status", status)

		if decoder.serverVersion >= ServerVersion.whatIfExtFields {
			self.initialMarginBefore = try container.decodeOptional(Double.self)
			//print("initialMarginBefore", initialMarginBefore)
			self.maintenanceMarginBefore = try container.decodeOptional(Double.self)
			//print("maintenanceMarginBefore", maintenanceMarginBefore)
			self.equityWithLoanBefore = try container.decodeOptional(Double.self)
			//print("equityWithLoanBefore", equityWithLoanBefore)
			self.initialMarginChange = try container.decodeOptional(Double.self)
			//print("initialMarginChange", initialMarginChange)
			self.maintenanceMarginChange = try container.decodeOptional(Double.self)
			//print("maintenanceMarginChange", maintenanceMarginChange)
			self.equityWithLoanChange = try container.decodeOptional(Double.self)
			//print("equityWithLoanChange", equityWithLoanChange)
		}

		self.initialMarginAfter = try container.decodeOptional(Double.self)
		//print("stainitialMarginAftertus", initialMarginAfter)
		self.maintenanceMarginAfter = try container.decodeOptional(Double.self)
		//print("maintenanceMarginAfter", maintenanceMarginAfter)
		self.equityWithLoanAfter = try container.decodeOptional(Double.self)
		//print("equityWithLoanAfter", equityWithLoanAfter)
		self.commission = try container.decodeOptional(Double.self)
		//print("commission", commission)
		self.minCommission = try container.decodeOptional(Double.self)
		//print("minCommission", minCommission)
		self.maxCommission = try container.decodeOptional(Double.self)
		//print("maxCommission", maxCommission)
		self.commissionCurrency = try container.decodeOptional(String.self)
		//print("commissionCurrency", commissionCurrency)

		
		if decoder.serverVersion >= ServerVersion.fullOrderPreviewFields {
			self.marginCurrency = try container.decodeOptional(String.self)
			//print("marginCurrency", marginCurrency)
			self.initialMarginBeforeOutsideRTH = try container.decodeOptional(Double.self)
			//print("initialMarginBeforeOutsideRTH", initialMarginBeforeOutsideRTH)
			self.maintenanceMarginBeforeOutsideRTH = try container.decodeOptional(Double.self)
			//print("maintenanceMarginBeforeOutsideRTH", maintenanceMarginBeforeOutsideRTH)
			self.equityWithLoanBeforeOutsideRTH = try container.decodeOptional(Double.self)
			//print("equityWithLoanBeforeOutsideRTH", equityWithLoanBeforeOutsideRTH)
			self.initialMarginChangeOutsideRTH = try container.decodeOptional(Double.self)
			//print("initialMarginChangeOutsideRTH", initialMarginChangeOutsideRTH)
			self.maintenanceMarginChangeOutsideRTH = try container.decodeOptional(Double.self)
			//print("maintenanceMarginChangeOutsideRTH", maintenanceMarginChangeOutsideRTH)
			self.equityWithLoanChangeOutsideRTH = try container.decodeOptional(Double.self)
			//print("equityWithLoanChangeOutsideRTH", equityWithLoanChangeOutsideRTH)
			self.initialMarginAfterOutsideRTH = try container.decodeOptional(Double.self)
			//print("initialMarginAfterOutsideRTH", initialMarginAfterOutsideRTH)
			self.maintenanceMarginAfterOutsideRTH = try container.decodeOptional(Double.self)
			//print("maintenanceMarginAfterOutsideRTH", maintenanceMarginAfterOutsideRTH)
			self.equityWithLoanAfterOutsideRTH = try container.decodeOptional(Double.self)
			//print("equityWithLoanAfterOutsideRTH", equityWithLoanAfterOutsideRTH)
			self.suggestedSize = try container.decodeOptional(Double.self)
			//print("suggestedSize", suggestedSize)
			self.rejectReason = try container.decodeOptional(String.self)
			//print("rejectReason", rejectReason)

			let accountsCount = try container.decode(Int.self)
			//print("accountsCount", accountsCount)
			var allocations: [OrderAllocation] = []
			for _ in 0..<accountsCount {
				let temp = try decoder.decode(OrderAllocation.self)
				allocations.append(temp)
			}
			self.allocations = allocations
		}

		self.warning = try container.decodeOptional(String.self)

	}
	
}

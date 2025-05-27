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





public struct PlaceOrderRequest: IdentifiableRequest {
	
	public let type: RequestType = .placeOrder
	
	public let version: Int = 45
	
	public let id: Int
	
	public let contract: Contract
	
	public let order: Order
	
	/**
	 Creates new request to place orderd
	 - parameter id: Order id.
	 - parameter contract: Contract to be traded
	 - parameter order: Order object
	 
	 - Note: for bracket orders (eg entry + stop loss) the child order should r
	 */
	public init (id: Int, contract: Contract , order: Order) {
		self.id = id
		self.contract = contract
		self.order = order
	}
	
}

extension PlaceOrderRequest: IBEncodable {
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
		
		let version = encoder.serverVersion < .notHeld ?  27 : 45
		
		try container.encodeOptional(type)
		
		if encoder.serverVersion < .orderContainer{
			try container.encodeOptional(version)
		}
		
		try container.encodeOptional(id)

		/// MARK: - CONTRACT DATA
		try container.encodeOptional(contract.id ?? 0)
		try container.encodeOptional(contract.symbol)
		try container.encodeOptional(contract.type)
		try container.encodeOptional(contract.expiration)
		try container.encodeOptional(contract.strike ?? 0)
		try container.encodeOptional(contract.right)
		try container.encodeOptional(contract.multiplier)
		try container.encodeOptional(contract.exchange)
		try container.encodeOptional(contract.primaryExchange)
		try container.encodeOptional(contract.currency)
		try container.encodeOptional(contract.localSymbol)
		try container.encodeOptional(contract.tradingClass)

		if encoder.serverVersion >= .secIdType{
			try container.encodeOptional(contract.globalID?.type)
			try container.encodeOptional(contract.globalID?.identifier)
		}
		
		// Encode main order fields
		try container.encodeOptional(order.action)

		if encoder.serverVersion >= .fractionalPositions{
			try container.encodeOptional(order.totalQuantity)
		} else {
			try container.encodeOptional(Int(order.totalQuantity ?? 0))
		}
		
		try container.encodeOptional(order.orderType)

		if encoder.serverVersion >= .orderComboLegsPrice {
			try container.encodeOptional(order.lmtPrice)
			try container.encodeOptional(order.auxPrice)
		} else {
			try container.encodeOptional(order.lmtPrice ?? 0)
			try container.encodeOptional(order.auxPrice ?? 0)
		}

		
		try container.encodeOptional(order.tif)
		try container.encodeOptional(order.ocaGroup)
		try container.encodeOptional(order.accountName)
		try container.encodeOptional(order.openClose)
		try container.encodeOptional(order.origin)
		try container.encodeOptional(order.orderRef)
		try container.encodeOptional(order.transmit)
		try container.encodeOptional(order.parentId)
		try container.encodeOptional(order.blockOrder)
		try container.encodeOptional(order.sweepToFill)
		try container.encodeOptional(order.displaySize)
		try container.encodeOptional(order.triggerMethod)
		try container.encodeOptional(order.outsideRth)
		try container.encodeOptional(order.hidden)

		// Encode combo legs for BAG requests
		if contract.type == .combo {
			let comboLegsCount = contract.comboLegs?.count ?? 0
			try container.encodeOptional(comboLegsCount)
			try contract.comboLegs?.forEach { comboLeg in
				try container.encodeOptional(comboLeg.id)
				try container.encodeOptional(comboLeg.ratio)
				try container.encodeOptional(comboLeg.action)
				try container.encodeOptional(comboLeg.exchange)
				try container.encodeOptional(comboLeg.openClose)
				try container.encodeOptional(comboLeg.shortSaleSlot)
				try container.encodeOptional(comboLeg.designatedLocation)
				if encoder.serverVersion >= .sshortxOld{
					try container.encodeOptional(comboLeg.exemptCode)
				}
			}
		}
		
		// Encode order combo legs for Combo requests
		if encoder.serverVersion >= .orderComboLegsPrice && contract.type == .combo {
			let orderComboLegsCount = order.orderComboLegs?.count ?? 0
			try container.encodeOptional(orderComboLegsCount)
			try order.orderComboLegs?.forEach{ orderComboLeg in
				try container.encodeOptional(orderComboLeg.price)
			}
		}
		
		
		if encoder.serverVersion >= .smartComboRoutingParams && contract.type == .combo {
			let smartComboRoutingParamsCount = order.smartComboRoutingParams?.count ?? 0
			try container.encodeOptional(smartComboRoutingParamsCount)
			try order.smartComboRoutingParams?.forEach{ (key,value) in
				try container.encodeOptional(key)
				try container.encodeOptional(value)
			}
		}
		
		
		try container.encodeNil()
		try container.encodeOptional(order.discretionaryAmt)
		try container.encodeOptional(order.goodAfterTime)
		try container.encodeOptional(order.goodTillDate)
		try container.encodeOptional(order.faGroup)
		try container.encodeOptional(order.faMethod)
		try container.encodeOptional(order.faPercentage)

		if encoder.serverVersion < .FAProfileDesupport {
			try container.encodeNil()
		}
		
		if encoder.serverVersion >= .modelsSupport{
			try container.encodeOptional(order.modelCode)
		}
		
		try container.encodeOptional(order.shortSaleSlot?.rawValue ?? 0)
		try container.encodeOptional(order.designatedLocation)

		if encoder.serverVersion >= .sshortxOld{
			try container.encodeOptional(order.exemptCode)
		}
		
		try container.encodeOptional(order.ocaType)
		try container.encodeOptional(order.rule80A)
		try container.encodeOptional(order.settlingFirm)
		try container.encodeOptional(order.allOrNone)
		try container.encodeOptional(order.minQty)
		try container.encodeOptional(order.percentOffset)
		try container.encodeOptional(false)
		try container.encodeOptional(false)
		try container.encodeNil()
		try container.encodeOptional(order.auctionStrategy?.rawValue ?? 0)
		try container.encodeOptional(order.startingPrice)
		try container.encodeOptional(order.stockRefPrice)
		try container.encodeOptional(order.delta)
		try container.encodeOptional(order.stockRangeLower)
		try container.encodeOptional(order.stockRangeUpper)
		try container.encodeOptional(order.overridePercentageConstraints)

		// Volatility orders (srv v26 and above)
		try container.encodeOptional(order.volatility)
		try container.encodeOptional(order.volatilityType)
		try container.encodeOptional(order.deltaNeutralOrderType)
		try container.encodeOptional(order.deltaNeutralAuxPrice)

		if encoder.serverVersion >= .deltaNeutralConid && order.deltaNeutralOrderType != nil {
			try container.encodeOptional(order.deltaNeutralConId)
			try container.encodeOptional(order.deltaNeutralSettlingFirm)
			try container.encodeOptional(order.deltaNeutralClearingAccount)
			try container.encodeOptional(order.deltaNeutralClearingIntent)
		}
		
		if encoder.serverVersion >= .deltaNeutralOpenClose && order.deltaNeutralOrderType != nil {
			try container.encodeOptional(order.deltaNeutralOpenClose)
			try container.encodeOptional(order.deltaNeutralShortSale)
			try container.encodeOptional(order.deltaNeutralShortSaleSlot)
			try container.encodeOptional(order.deltaNeutralDesignatedLocation)
		}
		
		try container.encodeOptional(order.continuousUpdate)
		try container.encodeOptional(order.referencePriceType)
		try container.encodeOptional(order.trailStopPrice )

		if encoder.serverVersion >= .trailingPercent{
			try container.encodeOptional(order.trailingPercent)
		}
		
		
		// SCALE orders
		if encoder.serverVersion >= .scaleOrders{
			try container.encodeOptional(order.scaleInitLevelSize)
			try container.encodeOptional(order.scaleSubsLevelSize)
		} else {
			try	container.encodeOptional("")
			try container.encodeOptional(order.scaleInitLevelSize)
		}
			
		try container.encodeOptional(order.scalePriceIncrement)

		if (
			encoder.serverVersion >= .scaleOrders3
			&& order.scalePriceIncrement != nil
			&& order.scalePriceIncrement > 0.0
		){
			try container.encodeOptional(order.scalePriceAdjustValue)
			try container.encodeOptional(order.scalePriceAdjustInterval)
			try container.encodeOptional(order.scaleProfitOffset)
			try container.encodeOptional(order.scaleAutoReset)
			try container.encodeOptional(order.scaleInitPosition)
			try container.encodeOptional(order.scaleInitFillQty)
			try container.encodeOptional(order.scaleRandomPercent)
		}
			
		if encoder.serverVersion >= .scaleTable{
			try container.encodeOptional(order.scaleTable)
			try container.encodeOptional(order.activeStartTime)
			try container.encodeOptional(order.activeStopTime)
		}
			
		// HEDGE orders
		if encoder.serverVersion >= .hedgeOrders{
			try container.encodeOptional(order.hedgeType)
			if order.hedgeType != nil {
				try container.encodeOptional(order.hedgeParam)
			}
		}
		
		if encoder.serverVersion >= .optOutSmartRouting {
			try container.encodeOptional(order.optOutSmartRouting)
			// print("order.optOutSmartRouting",order.optOutSmartRouting)
		}
		
		if encoder.serverVersion >= .ptaOrders{
			try container.encodeOptional(order.clearingAccount)
			try container.encodeOptional(order.clearingIntent)
		}
		if encoder.serverVersion >= .notHeld{
			try container.encodeOptional(order.notHeld)
		}
		
		if encoder.serverVersion >= .deltaNeutral{
			if contract.deltaNeutralContract != nil {
				try container.encodeOptional(true)
				try container.encodeOptional(contract.deltaNeutralContract?.id)
				try container.encodeOptional(contract.deltaNeutralContract?.delta)
				try container.encodeOptional(contract.deltaNeutralContract?.price)
			} else {
				try container.encodeOptional(false)
			}
		}
		
		
		if encoder.serverVersion >= .algoOrders {
			try container.encodeOptional(order.algoStrategy)
			if order.algoStrategy != nil{
				let algoParamsCount = order.algoParams?.count ?? 0
				try container.encodeOptional(algoParamsCount)
				try order.algoParams?.forEach{(key,value) in
					try container.encodeOptional(key)
					try container.encodeOptional(value)
				}
			}
		}
		
		if encoder.serverVersion >= .algoId{
			try container.encodeOptional(order.algoId)
		}
		
		try container.encodeOptional(order.whatIf)

		// Encode miscOptions parameter
		if encoder.serverVersion >= .linking{
			try container.encodeOptional(order.orderMiscOptions)
		}
		
		if encoder.serverVersion >= .orderSolicited {
			try container.encodeOptional(order.solicited)
		}
		
		if encoder.serverVersion >= .randomizeSizeAndPrice {
			try container.encodeOptional(order.randomizeSize)
			try container.encodeOptional(order.randomizePrice)
		}
			
		if encoder.serverVersion >= .peggedToBenchmark {
			if order.orderType == .PEG_BENCH {
				try container.encodeOptional(order.referenceContractId)
				try container.encodeOptional(order.isPeggedChangeAmountDecrease)
				try container.encodeOptional(order.peggedChangeAmount)
				try container.encodeOptional(order.referenceChangeAmount)
				try container.encodeOptional(order.referenceExchangeId)
			}
			
			try container.encodeOptional(order.conditions?.count ?? 0)
			if order.conditions != nil {
				try container.encodeOptional(order.conditions)
				try container.encodeOptional(order.conditionsIgnoreRth)
				try container.encodeOptional(order.conditionsCancelOrder)
			}
			
			try container.encodeOptional(order.adjustedOrderType)
			try container.encodeOptional(order.triggerPrice ?? encoder.UNSET_DOUBLE)
			try container.encodeOptional(order.lmtPriceOffset ?? encoder.UNSET_DOUBLE)
			try container.encodeOptional(order.adjustedStopPrice ?? encoder.UNSET_DOUBLE)
			try container.encodeOptional(order.adjustedStopLimitPrice ?? encoder.UNSET_DOUBLE)
			try container.encodeOptional(order.adjustedTrailingAmount ?? encoder.UNSET_DOUBLE)
			try container.encodeOptional(order.adjustableTrailingUnit ?? 0)
		}
			

		if encoder.serverVersion >= .extOperator {
			try container.encodeOptional(order.extOperator)
		}
		
		if encoder.serverVersion >= .softDollarTier {
			try container.encodeOptional(order.softDollarTiers?.name)
			try container.encodeOptional(order.softDollarTiers?.value)
		}
			
		if encoder.serverVersion >= .cashQty{
			try container.encodeOptional(order.cashQty ?? encoder.UNSET_DOUBLE)
		}
		
		if encoder.serverVersion >= .decisionMaker{
			try container.encodeOptional(order.mifid2DecisionMaker)
			try container.encodeOptional(order.mifid2DecisionAlgo)
		}
		
		if encoder.serverVersion >= .mifidExecution{
			try container.encodeOptional(order.mifid2ExecutionTrader)
			try container.encodeOptional(order.mifid2ExecutionAlgo)
		}
		
		if encoder.serverVersion >= .autoPriceForHedge{
			try container.encodeOptional(order.dontUseAutoPriceForHedge)
		}
		
		if encoder.serverVersion >= .orderContainer {
			try container.encodeOptional(order.isOmsContainer)
		}
		
		if encoder.serverVersion >= .dPegOrders{
			try container.encodeOptional(order.discretionaryUpToLimitPrice)
		}
		
		if encoder.serverVersion >= .priceMgmtAlgo{
			try container.encodeOptional(order.usePriceMgmtAlgo)
		}
		
		if encoder.serverVersion >= .duration{
			try container.encodeOptional(order.duration ?? encoder.UNSET_INTEGER)
		}
		
		if encoder.serverVersion >= .postToAts{
			try container.encodeOptional(order.postToAts ?? encoder.UNSET_INTEGER)
		}
		
		if encoder.serverVersion >= .autoCancelParent{
			try container.encodeOptional(order.autoCancelParent)
		}
		
		if encoder.serverVersion >= .advancedOrderReject{
			try container.encodeOptional(order.advancedErrorOverride)
		}
		
		if encoder.serverVersion >= .manualOrderTime {
			try container.encodeOptional(order.manualOrderTime)
		}
		
		if encoder.serverVersion >= .pegbestPegmidOffsets{
			
			var sendMidOffsets: Bool = false
			
			if contract.exchange == "IBKRATS"{
				try container.encodeOptional(order.minTradeQty)
			}
			
			if order.orderType == .PEG_BEST{
				
				try container.encodeOptional(order.minCompeteSize)
				try container.encodeOptional(order.competeAgainstBestOffset)

				if order.competeAgainstBestOffset == Double.infinity {
					sendMidOffsets = true
				}
				
			} else if order.orderType == .PEG_MID {
				sendMidOffsets = true
			}
			
			if sendMidOffsets{
				try container.encodeOptional(order.midOffsetAtWhole)
				try container.encodeOptional(order.midOffsetAtHalf)
			}
			
		}
		
		if encoder.serverVersion >= .customerAccount {
			try container.encodeOptional(order.customerAccount)
		}
		
		if encoder.serverVersion >= .professionalCustomer {
			try container.encodeOptional(order.professionalCustomer)
		}
		
		if encoder.serverVersion >= .rfqFields  && encoder.serverVersion < .undoRfqFields{
			try container.encodeNil()
			try container.encodeOptional(Int.max)
		}
		
		if encoder.serverVersion >= .includeOvernight{
			try container.encodeOptional(order.includeOvernight)
		}
		
		if encoder.serverVersion >= .cmeTaggingFields{
			try container.encodeOptional(order.manualOrderIndicator ?? encoder.UNSET_INTEGER)
		}
	}
}



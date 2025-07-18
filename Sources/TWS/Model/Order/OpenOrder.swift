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




public struct OpenOrdersRequest: AnyRequest {
	
	public let type: RequestType
	
	private let version: Int = 1
	
	private let autoBind: Bool?

	private init(type: RequestType, autoBind: Bool? = nil) {
		self.type = type
		self.autoBind = autoBind
	}

	public static func standard() -> OpenOrdersRequest {
		OpenOrdersRequest(type: .openOrders)
	}

	public static func auto(autoBind: Bool) -> OpenOrdersRequest {
		OpenOrdersRequest(type: .openOrdersAuto, autoBind: autoBind)
	}

	public static func all() -> OpenOrdersRequest {
		OpenOrdersRequest(type: .openOrdersAll)
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)

		if type == .openOrdersAuto, let autoBind = autoBind {
			try container.encode(autoBind)
		}
	}
	
}




/**
 This function is called to feed in open orders.
 */
public struct OpenOrder:  IBEvent, IBDecodable, Identifiable {
	
	///The order ID assigned by TWS. Use to cancel or update TWS order.
	public let id: Int

	/// The Contract class attributes describe the contract.
	public let contract: Contract
	
	/// The Order class gives the details of the open order.
	public let order: Order
	
	///The orderState class includes attributes Used for both pre and post trade margin and commission and fees data.
	public let state: OrderState
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		
		let version = decoder.serverVersion < .orderContainer
		? try container.decode(Int.self)
		: decoder.serverVersion.rawValue
		
		var _contract = Contract()
		var _order = Order()
		var _state = OrderState()
		
		// decodeOrderId
		self.id = try container.decode(Int.self)
		_order.orderId = self.id
		
		// decodeContract
		_contract.id = try container.decodeOptional(Int.self)
		_contract.symbol = try container.decodeOptional(String.self)
		_contract.type = try container.decodeOptional(SecuritiesType.self)
		_contract.expiration = try container.decodeOptional(DateComponents.self)
		_contract.strike = try container.decodeOptional(Double.self)
		_contract.right = try container.decodeOptional(Contract.ExecutionRight.self)
		_contract.multiplier = try container.decodeOptional(Double.self)
		_contract.exchange = try container.decodeOptional(String.self)
		_contract.currency = try container.decodeOptional(String.self)
		_contract.localSymbol = try container.decodeOptional(String.self)
		_contract.tradingClass = try container.decodeOptional(String.self)

		// decodeAction
		_order.action = try container.decodeOptional(Order.Action.self)

		// decodeTotalQuantity
		_order.totalQuantity = try container.decodeOptional(Double.self)

		// decodeOrderType
		_order.orderType = try container.decodeOptional(OrderType.self)

		// decodeLmtPrice
		_order.lmtPrice = try container.decodeOptional(Double.self)

		// decodeAuxPrice
		_order.auxPrice = try container.decodeOptional(Double.self)

		// decodeTIF
		_order.tif = try container.decodeOptional(Order.TimeInForce.self)

		// decodeOcaGroup
		_order.ocaGroup = try container.decodeOptional(String.self)

		// decodeAccount
		_order.accountName = try container.decodeOptional(String.self)

		// decodeOpenClose
		_order.openClose = try container.decodeOptional(Order.OpenClose.self)

		// decodeOrigin
		_order.origin = try container.decode(Order.Origin.self)

		// decodeOrderRef
		_order.orderRef = try container.decodeOptional(String.self)

		// decodeClientId
		_order.clientId = try container.decodeOptional(Int.self)

		// decodePermId
		_order.permId = try container.decodeOptional(Int.self)

		// decodeOutsideRth
		_order.outsideRth = try container.decode(Bool.self)

		// decodeHidden
		_order.hidden = try container.decodeOptional(Bool.self)

		// decodeDiscretionaryAmt
		_order.discretionaryAmt = try container.decodeOptional(Double.self)

		// decodeGoodAfterTime
		_order.goodAfterTime = try container.decodeOptional(Date.self)

		// skipSharesAllocation
		_ = try container.decodeOptional(String.self)

		// decodeFAParams
		_order.faGroup = try container.decodeOptional(String.self)
		
		_order.faMethod = try container.decodeOptional(String.self)
		
		_order.faPercentage = try container.decodeOptional(String.self)

		if decoder.serverVersion < .FAProfileDesupport {
			_ = try container.decodeOptional(String.self) // skip deprecated faProfile field
		}
		
		// decodeModelCode
		if decoder.serverVersion >= .modelsSupport {
			_order.modelCode = try container.decodeOptional(String.self)
		}
		
		// decodeGoodTillDate
		_order.goodTillDate = try container.decodeOptional(Date.self)

		// decodeRule80A
		_order.rule80A = try container.decodeOptional(Order.Rule80AType.self)

		// decodePercentOffset
		_order.percentOffset = try container.decodeOptional(Double.self)

		// decodeSettlingFirm
		_order.settlingFirm = try container.decodeOptional(String.self)

		// decodeShortSaleParams
		_order.shortSaleSlot = try container.decodeOptional(Order.ShortSaleSlot.self)

		_order.designatedLocation = try container.decodeOptional(String.self)

		_order.exemptCode = try container.decode(Int.self)
		
		// decodeAuctionStrategy
		_order.auctionStrategy = try container.decodeOptional(Order.AuctionStrategy.self)

		// decodeBoxOrderParams
		_order.startingPrice = try container.decodeOptional(Double.self)
		
		_order.stockRefPrice = try container.decodeOptional(Double.self)
		
		_order.delta = try container.decodeOptional(Double.self)

		// decodePegToStkOrVolOrderParams
		_order.stockRangeLower = try container.decodeOptional(Double.self)

		_order.stockRangeUpper = try container.decodeOptional(Double.self)

		// decodeDisplaySize
		_order.displaySize = try container.decodeOptional(Int.self)

		// decodeBlockOrder
		_order.blockOrder = try container.decodeOptional(Bool.self)

		// decodeSweepToFill
		_order.sweepToFill = try container.decodeOptional(Bool.self)

		// decodeAllOrNone
		_order.allOrNone = try container.decodeOptional(Bool.self)

		// decodeMinQty
		_order.minQty = try container.decodeOptional(Int.self)

		// decodeOcaType
		_order.ocaType = try container.decodeOptional(Order.OcaType.self)

		// skipETradeOnly
		_ = try container.decodeOptional(Int.self)

		// skipFirmQuoteOnly
		_ = try container.decodeOptional(Int.self)

		// skipNbboPriceCap
		_ = try container.decodeOptional(Double.self)

		// decodeParentId
		_order.parentId = try container.decodeOptional(Int.self)

		// decodeTriggerMethod
		_order.triggerMethod = try container.decode(Order.TriggerMethod.self)


		// decodeVolOrderParams
		let readOpenOrderAttribs: Bool = true
		
		if version >= 11 {
			_order.volatility = try container.decodeOptional(Double.self)
			_order.volatilityType = try container.decodeOptional(Order.VolatilityType.self)
			_order.deltaNeutralOrderType = try container.decodeOptional(OrderType.self)
			_order.deltaNeutralAuxPrice = try container.decodeOptional(Double.self)

			if version >= 27 {
				_order.deltaNeutralConId = try container.decodeOptional(Int.self)
				if readOpenOrderAttribs == true {
					_order.deltaNeutralSettlingFirm = try container.decodeOptional(String.self)
					_order.deltaNeutralClearingAccount = try container.decodeOptional(String.self)
					_order.deltaNeutralClearingIntent = try container.decodeOptional(String.self)
				}
			}

			if version >= 31 {
				if readOpenOrderAttribs == true {
					_order.deltaNeutralOpenClose = try container.decodeOptional(String.self)
				}
				_order.deltaNeutralShortSale = try container.decodeOptional(Bool.self)
				_order.deltaNeutralShortSaleSlot = try container.decodeOptional(Int.self)
				_order.deltaNeutralDesignatedLocation = try container.decodeOptional(String.self)
			}
		}
			
		_order.continuousUpdate = try container.decodeOptional(Bool.self)
		_order.referencePriceType = try container.decodeOptional(Order.ReferencePriceType.self)

		// decodeTrailParams
		_order.trailStopPrice = try container.decodeOptional(Double.self)

		_order.trailingPercent = try container.decodeOptional(Double.self)
		
		// decodeBasisPoints
		_order.basisPoints = try container.decodeOptional(Double.self)
		_order.basisPointsType = try container.decodeOptional(Int.self)
		
		// decodeComboLegs
		_contract.comboLegsDescrip = try container.decodeOptional(String.self)
		

		if version >= 29 {
			let comboLegsCount = try container.decode(Int.self)
			var legs: [ComboLeg] = []
			for _ in 0..<comboLegsCount {
				let temp = try container.decode(ComboLeg.self)
				legs.append(temp)
			}
			_contract.comboLegs = legs.isEmpty ? nil : legs
			
			let orderComboLegsCount = try container.decode(Int.self)
			var orderLegs: [Order.ComboLeg] = []
			for _ in 0..<orderComboLegsCount {
				let temp = try container.decode(Order.ComboLeg.self)
				orderLegs.append(temp)
			}
			_order.orderComboLegs = orderLegs.isEmpty ? nil : orderLegs

		}

		// decodeSmartComboRoutingParams
		if version >= 26 {
			let routingParamsCount = try container.decode(Int.self)
			var routingParams: [String:String] = [:]
			for _ in 0..<routingParamsCount {
				let key = try container.decode(String.self)
				let value = try container.decode(String.self)
				routingParams[key] = value
			}
			_order.smartComboRoutingParams = routingParams
		}
		
		// decodeScaleOrderParams
		if version >= 15 {
			if version >= 20 {
				_order.scaleInitLevelSize = try container.decodeOptional(Int.self)
				_order.scaleSubsLevelSize = try container.decodeOptional(Int.self)
			}
			else {
				_ =  try container.decodeOptional(Int.self)
				_order.scaleInitLevelSize = try container.decodeOptional(Int.self)
			}
			_order.scalePriceIncrement = try container.decodeOptional(Double.self)
		}
		
		if version >= 28 && _order.scalePriceIncrement > 0.0 {
			_order.scalePriceAdjustValue = try container.decodeOptional(Double.self)
			_order.scalePriceAdjustInterval = try container.decodeOptional(Int.self)
			_order.scaleProfitOffset = try container.decodeOptional(Double.self)
			_order.scaleAutoReset = try container.decodeOptional(Bool.self)
			_order.scaleInitPosition = try container.decodeOptional(Int.self)
			_order.scaleInitFillQty = try container.decodeOptional(Int.self)
			_order.scaleRandomPercent = try container.decodeOptional(Bool.self)
		}
		
		// decodeHedgeParams
		if version >= 24 {
			_order.hedgeType = try container.decodeOptional(Order.HedgeType.self)
			if _order.hedgeType != nil {
				_order.hedgeParam = try container.decodeOptional(String.self)
			}
		}
		
		// decodeOptOutSmartRouting
		if version >= 25 {
			_order.optOutSmartRouting = try container.decodeOptional(Bool.self)
		}
		
		// decodeClearingParams
		if version >= 19 {
			_order.clearingAccount = try container.decodeOptional(String.self)
			_order.clearingIntent = try container.decode(Order.ClearingIntent.self)
		}
		
		// decodeNotHeld
		if version >= 22 {
			_order.notHeld = try container.decodeOptional(Bool.self)
		}
		
		// decodeDeltaNeutral
		if version >= 20 {
			let test = try container.decodeOptional(Bool.self)
			if test == true {
				_contract.deltaNeutralContract = try container.decodeOptional(DeltaNeutralContract.self)
			}
		}
		
		// decodeAlgoParams
		if version >= 21 {
			_order.algoStrategy = try container.decodeOptional(Order.AlgoStrategy.self)
		if _order.algoStrategy != nil {
				let algoParamsCount = try container.decode(Int.self)
				var temp:[String:String] = [:]
				for _ in 0..<algoParamsCount {
					let key = try container.decode(String.self)
					let value = try container.decode(String.self)
					temp[key] = value
				}
				_order.algoParams = temp
			}
		}
		
		// decodeSolicited
		if version >= 33 {
			_order.solicited = try container.decodeOptional(Bool.self)
		}
		
		// decodeWhatIfInfoAndCommissionAndFees
		_order.whatIf = try container.decode(Bool.self)
		_state = try OrderState(from: decoder)
		
		// decodeVolRandomizeFlags
		if version >= 34 {
			_order.randomizeSize = try container.decodeOptional(Bool.self)
			_order.randomizePrice = try container.decodeOptional(Bool.self)
		}
		
		// decodePegToBenchParams
		if decoder.serverVersion >= .peggedToBenchmark {
			if _order.orderType == .PEG_BENCH {
				_order.referenceContractId = try container.decodeOptional(Int.self)
				_order.isPeggedChangeAmountDecrease = try container.decodeOptional(Bool.self)
				_order.peggedChangeAmount = try container.decodeOptional(Double.self)
				_order.referenceChangeAmount = try container.decodeOptional(Double.self)
				_order.referenceExchange = try container.decodeOptional(String.self)
			}
		}
		
		// decodeConditions
		if decoder.serverVersion >= .peggedToBenchmark {
			
			let nConditions = try container.decodeOptional(Int.self)

			if nConditions > 0 {
				_order.conditions = try OrderConditions(from: decoder)
				_order.conditionsIgnoreRth = try container.decodeOptional(Bool.self)
				_order.conditionsCancelOrder = try container.decodeOptional(Bool.self)
			}
		}
		
		// decodeAdjustedOrderParams
		if decoder.serverVersion >= .peggedToBenchmark {
			_order.adjustedOrderType = try container.decodeOptional(OrderType.self)
			_order.triggerPrice = try container.decodeOptional(Double.self)

			_order.trailStopPrice = try container.decodeOptional(Double.self)
			_order.lmtPriceOffset = try container.decodeOptional(Double.self)
			_order.adjustedStopPrice = try container.decodeOptional(Double.self)
			_order.adjustedStopLimitPrice = try container.decodeOptional(Double.self)
			_order.adjustedTrailingAmount = try container.decodeOptional(Double.self)
			_order.adjustableTrailingUnit = try container.decodeOptional(Int.self)
		}
		
		// decodeSoftDollarTier
		if decoder.serverVersion >= .softDollarTier {
			_order.softDollarTiers = try container.decodeOptional(SoftDollarTier.self)
		}
		
		// decodeCashQty
		if decoder.serverVersion >= .cashQty {
			_order.cashQty = try container.decodeOptional(Double.self)
		}
		
		// decodeDontUseAutoPriceForHedge
		if decoder.serverVersion >= .autoPriceForHedge {
			_order.dontUseAutoPriceForHedge = try container.decodeOptional(Bool.self)
		}
		
		// decodeIsOmsContainers
		if decoder.serverVersion >= .orderContainer {
			_order.isOmsContainer = try container.decodeOptional(Bool.self)
		}
		
		// decodeDiscretionaryUpToLimitPrice
		if decoder.serverVersion >= .dPegOrders {
			_order.discretionaryUpToLimitPrice = try container.decodeOptional(Bool.self)
		}
		
		// decodeUsePriceMgmtAlgo
		if decoder.serverVersion >= .priceMgmtAlgo {
			_order.usePriceMgmtAlgo = try container.decode(Bool.self)
		}
		
		// decodeDuration
		if decoder.serverVersion >= .duration {
			_order.duration = try container.decodeOptional(Int.self)
		}
		
		// decodePostToAts
		if decoder.serverVersion >= .postToAts {
			_order.postToAts = try container.decodeOptional(Int.self)
		}
		
		// decodeAutoCancelParent
		if decoder.serverVersion.rawValue >= 100 {
			_order.autoCancelParent = try container.decode(Bool.self)
		}
		
		// decodePegBestPegMidOrderAttributes
		if decoder.serverVersion >= .pegbestPegmidOffsets {
			_order.minTradeQty = try container.decodeOptional(Int.self)
			_order.minCompeteSize = try container.decodeOptional(Int.self)
			_order.competeAgainstBestOffset = try container.decodeOptional(Double.self)
			_order.midOffsetAtWhole = try container.decodeOptional(Double.self)
			_order.midOffsetAtHalf = try container.decodeOptional(Double.self)
		}
		
		// decodeCustomerAccount
		if decoder.serverVersion >= .customerAccount {
			_order.customerAccount = try container.decodeOptional(String.self)
		}
		
		// decodeProfessionalCustomer
		if decoder.serverVersion >= .professionalCustomer {
			_order.professionalCustomer = try container.decodeOptional(Bool.self)
		}
		
		// decodeBondAccruedInterest
		if decoder.serverVersion >= .bondAccruedInterest {
			_order.bondAccruedInterest = try container.decodeOptional(Double.self)
		}
		
		// decodeIncludeOvernight
		if decoder.serverVersion >= .includeOvernight {
			_order.includeOvernight = try container.decode(Bool.self)
		}
		
		// decodeCMETaggingFields
		if decoder.serverVersion >= .cmeTaggingFieldsInOpenOrder {
			_order.extOperator = try container.decodeOptional(String.self)
			_order.manualOrderIndicator = try container.decodeOptional(Int.self)
		}
		
		self.order = _order
		self.contract = _contract
		self.state = _state
	}
	
}

	

/**
 This is called at the end of a given request for open orders
 */
public struct OpenOrderEnd:  IBEvent, IBDecodable {
	public let type: ResponseType = .openOrderEnd
	
	public init(from decoder: IBDecoder) throws {}
	
}




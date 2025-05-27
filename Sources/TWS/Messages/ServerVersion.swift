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



public struct ServerVersion: Sendable, Codable{
	
	public let rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public static let realTimeBars = ServerVersion(rawValue: 34)
	public static let scaleOrders = ServerVersion(rawValue: 35)
	public static let snapshotMktData = ServerVersion(rawValue: 35)
	public static let sshortComboLegs = ServerVersion(rawValue: 35)
	public static let whatIfOrders = ServerVersion(rawValue: 36)
	public static let contractConid = ServerVersion(rawValue: 37)
	public static let ptaOrders = ServerVersion(rawValue: 39)
	public static let fundamentalData = ServerVersion(rawValue: 40)
	public static let deltaNeutral = ServerVersion(rawValue: 40)
	public static let contractDataChain = ServerVersion(rawValue: 40)
	public static let scaleOrders2 = ServerVersion(rawValue: 40)
	public static let algoOrders = ServerVersion(rawValue: 41)
	public static let executionDataChain = ServerVersion(rawValue: 42)
	public static let notHeld = ServerVersion(rawValue: 44)
	public static let secIdType = ServerVersion(rawValue: 45)
	public static let placeOrderConid = ServerVersion(rawValue: 46)
	public static let reqMktDataConid = ServerVersion(rawValue: 47)
	public static let reqCalcImpliedVolat = ServerVersion(rawValue: 49)
	public static let reqCalcOptionPrice = ServerVersion(rawValue: 50)
	public static let sshortxOld = ServerVersion(rawValue: 51)
	public static let sshortx = ServerVersion(rawValue: 52)
	public static let reqGlobalCancel = ServerVersion(rawValue: 53)
	public static let hedgeOrders = ServerVersion(rawValue: 54)
	public static let reqMarketDataType = ServerVersion(rawValue: 55)
	public static let optOutSmartRouting = ServerVersion(rawValue: 56)
	public static let smartComboRoutingParams = ServerVersion(rawValue: 57)
	public static let deltaNeutralConid = ServerVersion(rawValue: 58)
	public static let scaleOrders3 = ServerVersion(rawValue: 60)
	public static let orderComboLegsPrice = ServerVersion(rawValue: 61)
	public static let trailingPercent = ServerVersion(rawValue: 62)
	public static let deltaNeutralOpenClose = ServerVersion(rawValue: 66)
	public static let positions = ServerVersion(rawValue: 67)
	public static let accountSummary = ServerVersion(rawValue: 67)
	public static let tradingClass = ServerVersion(rawValue: 68)
	public static let scaleTable = ServerVersion(rawValue: 69)
	public static let linking = ServerVersion(rawValue: 70)
	public static let algoId = ServerVersion(rawValue: 71)
	public static let optionalCapabilities = ServerVersion(rawValue: 72)
	public static let orderSolicited = ServerVersion(rawValue: 73)
	public static let linkingAuth = ServerVersion(rawValue: 74)
	public static let primaryExch = ServerVersion(rawValue: 75)
	public static let randomizeSizeAndPrice = ServerVersion(rawValue: 76)
	public static let fractionalPositions = ServerVersion(rawValue: 101)
	public static let peggedToBenchmark = ServerVersion(rawValue: 102)
	public static let modelsSupport = ServerVersion(rawValue: 103)
	public static let secDefOptParamsReq = ServerVersion(rawValue: 104)
	public static let extOperator = ServerVersion(rawValue: 105)
	public static let softDollarTier = ServerVersion(rawValue: 106)
	public static let reqFamilyCodes = ServerVersion(rawValue: 107)
	public static let reqMatchingSymbols = ServerVersion(rawValue: 108)
	public static let pastLimit = ServerVersion(rawValue: 109)
	public static let mdSizeMultiplier = ServerVersion(rawValue: 110)
	public static let cashQty = ServerVersion(rawValue: 111)
	public static let reqMktDepthExchanges = ServerVersion(rawValue: 112)
	public static let tickNews = ServerVersion(rawValue: 113)
	public static let reqSmartComponents = ServerVersion(rawValue: 114)
	public static let reqNewsProviders = ServerVersion(rawValue: 115)
	public static let reqNewsArticle = ServerVersion(rawValue: 116)
	public static let reqHistoricalNews = ServerVersion(rawValue: 117)
	public static let reqHeadTimestamp = ServerVersion(rawValue: 118)
	public static let reqHistogram = ServerVersion(rawValue: 119)
	public static let serviceDataType = ServerVersion(rawValue: 120)
	public static let aggGroup = ServerVersion(rawValue: 121)
	public static let underlyingInfo = ServerVersion(rawValue: 122)
	public static let cancelHeadtimestamp = ServerVersion(rawValue: 123)
	public static let syntRealtimeBars = ServerVersion(rawValue: 124)
	public static let cfdReroute = ServerVersion(rawValue: 125)
	public static let marketRules = ServerVersion(rawValue: 126)
	public static let accountPNL = ServerVersion(rawValue: 127)
	public static let newsQueryOrigins = ServerVersion(rawValue: 128)
	public static let unrealizedPnl = ServerVersion(rawValue: 129)
	public static let historicalTicks = ServerVersion(rawValue: 130)
	public static let marketCapPrice = ServerVersion(rawValue: 131)
	public static let preOpenBidAsk = ServerVersion(rawValue: 132)
	public static let realExpirationDate = ServerVersion(rawValue: 134)
	public static let realizedPnl = ServerVersion(rawValue: 135)
	public static let lastLiquidity = ServerVersion(rawValue: 136)
	public static let tickByTick = ServerVersion(rawValue: 137)
	public static let decisionMaker = ServerVersion(rawValue: 138)
	public static let mifidExecution = ServerVersion(rawValue: 139)
	public static let tickByTickIgnoreSize = ServerVersion(rawValue: 140)
	public static let autoPriceForHedge = ServerVersion(rawValue: 141)
	public static let whatIfExtFields = ServerVersion(rawValue: 142)
	public static let scannerGenericOpts = ServerVersion(rawValue: 143)
	public static let apiBindOrder = ServerVersion(rawValue: 144)
	public static let orderContainer = ServerVersion(rawValue: 145)
	public static let smartDepth = ServerVersion(rawValue: 146)
	public static let removeNullAllCasting = ServerVersion(rawValue: 147)
	public static let dPegOrders = ServerVersion(rawValue: 148)
	public static let mktDepthPrimExchange = ServerVersion(rawValue: 149)
	public static let completedOrders = ServerVersion(rawValue: 150)
	public static let priceMgmtAlgo = ServerVersion(rawValue: 151)
	public static let stockType = ServerVersion(rawValue: 152)
	public static let encodeMsgAscii7 = ServerVersion(rawValue: 153)
	public static let sendAllFamilyCodes = ServerVersion(rawValue: 154)
	public static let noDefaultOpenClose = ServerVersion(rawValue: 155)
	public static let priceBasedVolatility = ServerVersion(rawValue: 156)
	public static let replaceFAEnd = ServerVersion(rawValue: 157)
	public static let duration = ServerVersion(rawValue: 158)
	public static let marketDataInShares = ServerVersion(rawValue: 159)
	public static let postToAts = ServerVersion(rawValue: 160)
	public static let wsheCalendar = ServerVersion(rawValue: 161)
	public static let autoCancelParent = ServerVersion(rawValue: 162)
	public static let fractionalSizeSupport = ServerVersion(rawValue: 163)
	public static let sizeRules = ServerVersion(rawValue: 164)
	public static let historicalSchedule = ServerVersion(rawValue: 165)
	public static let advancedOrderReject = ServerVersion(rawValue: 166)
	public static let userInfo = ServerVersion(rawValue: 167)
	public static let cryptoAggregatedTrades = ServerVersion(rawValue: 168)
	public static let manualOrderTime = ServerVersion(rawValue: 169)
	public static let pegbestPegmidOffsets = ServerVersion(rawValue: 170)
	public static let wshEventDataFilters = ServerVersion(rawValue: 171)
	public static let ipoPrices = ServerVersion(rawValue: 172)
	public static let wshEventDataFiltersDate = ServerVersion(rawValue: 173)
	public static let instrumentTimezone = ServerVersion(rawValue: 174)
	public static let hmdsMarketDataInShares = ServerVersion(rawValue: 175)
	public static let bondIssuerid = ServerVersion(rawValue: 176)
	public static let FAProfileDesupport = ServerVersion(rawValue: 177)
	public static let pendingPriceRevision = ServerVersion(rawValue: 178)
	public static let fundDataFields = ServerVersion(rawValue: 179)
	public static let manualOrderTimeExerciseOptions = ServerVersion(rawValue: 180)
	public static let openOrderAdStrategy = ServerVersion(rawValue: 181)
	public static let lastTradeDate = ServerVersion(rawValue: 182)
	public static let customerAccount = ServerVersion(rawValue: 183)
	public static let professionalCustomer = ServerVersion(rawValue: 184)
	public static let bondAccruedInterest = ServerVersion(rawValue: 185)
	public static let ineligibilityReasons = ServerVersion(rawValue: 186)
	public static let rfqFields = ServerVersion(rawValue: 187)
	public static let bondTradingHours = ServerVersion(rawValue: 188)
	public static let includeOvernight = ServerVersion(rawValue: 189)
	public static let undoRfqFields = ServerVersion(rawValue: 190)
	public static let permIdAsLong = ServerVersion(rawValue: 191)
	public static let cmeTaggingFields = ServerVersion(rawValue: 192)
	public static let cmeTaggingFieldsInOpenOrder = ServerVersion(rawValue: 193)
	public static let errorTime = ServerVersion(rawValue: 194)
	public static let fullOrderPreviewFields = ServerVersion(rawValue: 195)
}


extension ServerVersion: Comparable, Equatable {
	
	public static func < (lhs: ServerVersion, rhs: ServerVersion) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
	
	public static func == (lhs: ServerVersion, rhs: ServerVersion) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}

}


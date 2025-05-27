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




public enum RequestType: Int, Encodable, Sendable {
	case marketData = 1
	case marketDataCancel = 2
	case placeOrder = 3
	case orderCancel = 4
	case openOrders = 5
	case accountUpdate = 6
	case executions = 7
	case nextID = 8
	case contractDetails = 9
	case marketDepth = 10
	case marketDepthCancel = 11
	case newsBulletins = 12
	case newsBulletinsCancel = 13
	case setServerLogLevel = 14
	case openOrdersAuto = 15
	case openOrdersAll = 16
	case managedAccounts = 17
	case advisor = 18
	case advisorReplace = 19
	case historicalData = 20
	case exerciseOptions = 21
	case scannerSubscription = 22
	case scannerSubscriptionCancel = 23
	case scannerParameters = 24
	case historicalDataCancel = 25
	case currentTime = 49
	case realTimeBars = 50
	case realTimeBarsCancel = 51
	case fundamentalData = 52
	case fundamentalDataCancel = 53
	case calcImpliedVolatility = 54
	case calcOptionPrice = 55
	case calcImpliedVolatilityCancel = 56
	case calcOptionPriceCancel = 57
	case globalCancel = 58
	case marketDataType = 59
	case positionSize = 61
	case accountSummary = 62
	case accountSummaryCancel = 63
	case positionSizeCancel = 64
	case verifyRequest = 65
	case verifyMessage = 66
	case queryDisplayGroups = 67
	case subscribeToGroupEvents = 68
	case updateDisplayGroup = 69
	case unsubscribeFromGroupEvents = 70
	case startAPI = 71
	case verifyAndAuthRequest = 72
	case verifyAndAuthMessage = 73
	case positionSizeMulti = 74
	case positionSizeMultiCancel = 75
	case accountUpdatesMulti = 76
	case accountUpdatesMultiCancel = 77
	case optionParameters = 78
	case softDollarTiers = 79
	case familyCodes = 80
	case matchingSymbols = 81
	case marketDepthExchanges = 82
	case smartComponents = 83
	case newsArticle = 84
	case newsProviders = 85
	case historicalNews = 86
	case headTimestamp = 87
	case histogramData = 88
	case histogramDataCancel = 89
	case headTimestampCancel = 90
	case marketRule = 91
	case accountPnL = 92
	case accountPnLCancel = 93
	case positionPnL = 94
	case positionPnLCancel = 95
	case historicalTicks = 96
	case tickByTickData = 97
	case tickByTickDataCancel = 98
	case completedOrders = 99
	case wshMetaData = 100
	case wshMetaDataCancel = 101
	case wshEventData = 102
	case wshEventDataCancel = 103
	case userInfo = 104
}

public extension RequestType{
	
	var isCancellable: Bool {
		switch self{
		case .accountPnL: return true
		case .accountUpdate: return true
		case .accountUpdatesMulti: return true
		case .fundamentalData: return true
		case .historicalData: return true
		case .histogramData: return true
		case .headTimestamp: return true
		case .calcImpliedVolatility: return true
		case .marketData: return true
		case .marketDepth: return true
		case .newsBulletins: return	true
		case .calcOptionPrice: return true
		case .positionSize: return true
		case .positionSizeMulti: return true
		case .placeOrder: return true
		case .realTimeBars: return true
		case .scannerSubscription: return true
		case .positionPnL: return true
		case .tickByTickData: return true
		case .wshMetaData: return true
		case .wshEventData: return true
		default: return false
		}
	}
	
	var isIdentifiable: Bool {
		switch self{
		case .accountPnL: return true
		case .accountPnLCancel: return true
		case .accountSummary: return true
		case .accountUpdatesMulti: return true
		case .accountUpdatesMultiCancel: return true
		case .contractDetails: return true
		case .fundamentalData: return true
		case .fundamentalDataCancel: return true
		case .headTimestamp: return true
		case .headTimestampCancel: return true
		case .histogramData: return true
		case .histogramDataCancel: return true
		case .historicalData: return true
		case .historicalDataCancel: return true
		case .historicalNews: return true
		case .marketData: return true
		case .marketDataCancel: return true
		case .marketDepth: return true
		case .marketDepthCancel: return true
		case .matchingSymbols: return true
		case .optionParameters: return true
		case .executions: return true
		case .openOrders: return true
		case .placeOrder: return true
		case .orderCancel: return true
		case .positionSizeMulti: return true
		case .positionSizeMultiCancel: return true
		case .positionPnL: return true
		case .realTimeBars: return true
		case .realTimeBarsCancel: return true
		case .tickByTickData: return true
		case .tickByTickDataCancel: return true
		default: return false
		}
	}
	
	func corresponds(to responseType: ResponseType) -> Bool {
		return true
	}
		
}

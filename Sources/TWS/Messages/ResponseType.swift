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


public enum ResponseType: Int, Decodable, Sendable {
    case tickPrice = 1
    case tickSize = 2
    case orderStatus = 3
    case errorMessage = 4
    case openOrder = 5
    case accountValue = 6
    case positionUpdate = 7
    case accountUpdateTime = 8
    case nextValidId = 9
    case contractData = 10
    case executionData = 11
    case marketDepth = 12
    case marketDepthL2 = 13
    case newsBulletins = 14
    case managedAccounts = 15
    case receiveFA = 16
    case historicalData = 17
    case bondContractData = 18
    case scannerParameters = 19
    case scannerData = 20
    case tickOptionComputation = 21
    case tickGeneric = 45
    case tickString = 46
    case tickEfp = 47
    case currentTime = 49
    case realTimeBars = 50
    case fundamentalData = 51
    case contractDataEnd = 52
    case openOrderEnd = 53
    case accountDownloadEnd = 54
    case executionDataEnd = 55
    case deltaNeutralValidation = 56
    case tickSnapshotEnd = 57
    case marketDataType = 58
    case commissionAndFeesReport = 59
    case positionSize = 61
    case positionSizeEnd = 62
    case accountSummary = 63
    case accountSummaryEnd = 64
    case verifyMessageApi = 65
    case verifyCompleted = 66
    case displayGroupList = 67
    case displayGroupUpdated = 68
    case verifyAndAuthMessageApi = 69
    case verifyAndAuthCompleted = 70
    case positionMulti = 71
    case positionMultiEnd = 72
    case accountUpdateMulti = 73
    case accountUpdateMultiEnd = 74
    case securityDefinitionOptionParameter = 75
    case securityDefinitionOptionParameterEnd = 76
    case softDollarTiers = 77
    case familyCodes = 78
    case symbolSamples = 79
    case mktDepthExchanges = 80
    case tickReqParams = 81
    case smartComponents = 82
    case newsArticle = 83
    case tickNews = 84
    case newsProviders = 85
    case historicalNews = 86
    case historicalNewsEnd = 87
    case headTimestamp = 88
    case histogramData = 89
    case historicalDataUpdate = 90
    case rerouteMktDataReq = 91
    case rerouteMktDepthReq = 92
    case marketRule = 93
    case accountPNL = 94
    case positionPNL = 95
    case historicalTicks = 96
    case historicalTicksBidAsk = 97
    case historicalTicksLast = 98
    case tickByTick = 99
    case orderBound = 100
    case completedOrder = 101
    case completedOrdersEnd = 102
    case replaceFAEnd = 103
    case wshMetaData = 104
    case wshEventData = 105
    case historicalSchedule = 106
    case userInfo = 107
}

extension ResponseType {
	
	var origin: RequestType? {
		switch self {
		case .accountValue: return .accountUpdate
		case .positionUpdate: return .accountUpdate
		case .accountUpdateTime: return .accountUpdate
		case .nextValidId: return .nextID
		case .managedAccounts: return .managedAccounts
		case .receiveFA: return .advisor
		case .scannerParameters: return .scannerParameters
		case .currentTime: return .currentTime
		case .openOrderEnd: return .openOrders
		case .completedOrdersEnd: return .completedOrders
		case .accountDownloadEnd: return .accountUpdate
		case .commissionAndFeesReport: return .executions
		case .positionSize: return .positionSize
		case .positionSizeEnd: return .positionSize
		case .newsProviders: return .newsProviders
		case .familyCodes: return .familyCodes
		case .mktDepthExchanges: return .marketDepthExchanges
		case .newsBulletins: return .newsBulletins
		default: return nil
		}
	}
	
}

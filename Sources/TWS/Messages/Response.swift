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
 generic success payload
 */
public protocol IBEvent: Sendable {
	
}

public protocol IBIdentifiableEvent: Sendable {
	var id: Int {get}
}


/**
 streaming response message
 */
public struct Response: IBDecodable {
	
	/// message type
	public let type: ResponseType
	
	public let requestId: Int?
	
	public let result: Result<IBEvent,IBError>
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		type = try container.decode(ResponseType.self)
		
		switch type {
			
		case .errorMessage:
			let payload = try container.decode(ErrorMessage.self)
			result = .failure(payload.error)
			requestId = payload.id

		case .tickPrice:
			let payload = try container.decode(TickDecoder.self)
			result = .success(payload.result)
			requestId = payload.id

		case .tickSize:
			let payload = try container.decode(TickDecoder.self)
			result = .success(payload.result)
			requestId = payload.id

		case .tickGeneric:
			let payload = try container.decode(TickDecoder.self)
			result = .success(payload.result)
			requestId = payload.id

		case .tickString:
			let payload = try container.decode(TickDecoder.self)
			result = .success(payload.result)
			requestId = payload.id

		case .tickOptionComputation:
			let payload = try  container.decode(TickOptionComputation.self)
			result = .success(payload)
			requestId = payload.id

		case .tickEfp:
			let payload = try  container.decode(TickEFP.self)
			result = .success(payload)
			requestId = payload.id

		case .orderStatus:
			let payload = try container.decode(OrderStatus.self)
			result = .success(payload)
			requestId = payload.id

		case .openOrder:
			let payload = try container.decode(OpenOrder.self)
			result = .success(payload)
			requestId = payload.id

		case .accountValue:

			let rawValue = try decoder.peek(offset: 1)
			guard let type = AccountUpdateKeys(rawValue: rawValue) else {
				throw IBError.decodingError("Unable to decode AccountUpdateKeys")
			}
			
			switch type.valueType{
			case is String.Type:
				let payload = try container.decode(AccountUpdate<String>.self)
				result = .success(payload)
				requestId = nil //payload.accountName
			default:
				let payload = try container.decode(AccountUpdate<Double>.self)
				result = .success(payload)
				requestId = nil //payload.accountName
			}
			
		case .accountSummary:
						
			let rawValue = try decoder.peek(offset: 3)
			
			guard let type = AccountSummaryKeys(rawValue: rawValue) else {
				print(rawValue, decoder.description)
				throw IBError.decodingError("Unable to decode AccountSummaryKeys")
			}
			
			switch type.valueType{
			case is String.Type:
				let payload = try  container.decode(AccountSummary<String>.self)
				result = .success(payload)
				requestId = payload.id
			default:
				let payload = try  container.decode(AccountSummary<Double>.self)
				result = .success(payload)
				requestId = payload.id
			}
			
		case .accountSummaryEnd:
			let payload = try  container.decode(AccountSummaryEnd.self)
			result = .success(payload)
			requestId = payload.id
			
			
		case .accountUpdateMulti:
						
			let rawValue = try decoder.peek(offset: 4)
			guard let type = AccountUpdateKeys(rawValue: rawValue) else {
				throw IBError.decodingError("Unable to decode key")
			}
			
			switch type.valueType{
			case is String.Type:
				let payload = try  container.decode(AccountUpdateMulti<String>.self)
				result = .success(payload)
				requestId = payload.id

			default:
				let payload = try  container.decode(AccountUpdateMulti<Double>.self)
				result = .success(payload)
				requestId = payload.id
			}
			
		case .accountUpdateMultiEnd:
			let payload = try  container.decode(AccountUpdateMultiEnd.self)
			result = .success(payload)
			requestId = payload.id
			
		case .positionUpdate:
			let payload = try container.decode(PositionUpdate.self)
			result = .success(payload)
			requestId = nil //payload.accountName

		case .accountUpdateTime:
			let payload = try  container.decode(AccountUpdateTime.self)
			result = .success(payload)
			requestId = nil

		case .nextValidId:
			let payload = try  container.decode(NextRequestID.self)
			result = .success(payload)
			requestId = nil

		case .contractData:
			let payload = try  container.decode(ContractDetailsMessage.self)
			result = .success(payload)
			requestId = payload.id

		case .executionData:
			let payload = try  container.decode(Execution.self)
			result = .success(payload)
			requestId = payload.id

		case .marketDepth:
			let payload = try  container.decode(MarketDepthUpdate.self)
			result = .success(payload)
			requestId = payload.id

		case .marketDepthL2:
			let payload = try  container.decode(MarketDepthUpdateL2.self)
			result = .success(payload)
			requestId = payload.id

		case .newsBulletins:
			let payload = try  container.decode(NewsBulletin.self)
			result = .success(payload)
			requestId = nil

		case .managedAccounts:
			let payload = try  container.decode(ManagedAccounts.self)
			result = .success(payload)
			requestId = nil

		case .receiveFA:
			let payload = try  container.decode(ReceiveFA.self)
			result = .success(payload)
			requestId = nil

		case .historicalData:
			let payload = try  container.decode(HistoricalData.self)
			result = .success(payload)
			requestId = payload.id

		case .bondContractData:
			let payload = try  container.decode(BondDetailsMessage.self)
			result = .success(payload)
			requestId = payload.id

		case .scannerParameters:
			let payload = try  container.decode(ScannerParameters.self)
			result = .success(payload)
			requestId = nil

		case .scannerData:
			let payload = try  container.decode(ScannerData.self)
			result = .success(payload)
			requestId = payload.id

		case .currentTime:
			let payload = try  container.decode(ServerTime.self)
			result = .success(payload)
			requestId = nil

		case .realTimeBars:
			let payload = try  container.decode(RealtimeBar.self)
			result = .success(payload)
			requestId = payload.id

		case .fundamentalData:
			let payload = try  container.decode(FundamentalData.self)
			result = .success(payload)
			requestId = payload.id

		case .contractDataEnd:
			let payload = try  container.decode(ContractDetailsEndMessage.self)
			result = .success(payload)
			requestId = payload.id

		case .openOrderEnd:
			let payload = try  container.decode(OpenOrderEnd.self)
			result = .success(payload)
			requestId = nil

		case .accountDownloadEnd:
			let payload = try  container.decode(AccountUpdateEnd.self)
			result = .success(payload)
			requestId = nil

		case .executionDataEnd:
			let payload = try  container.decode(ExecutionEnd.self)
			result = .success(payload)
			requestId = payload.id

		case .deltaNeutralValidation:
			let payload = try  container.decode(DeltaNeutralValidation.self)
			result = .success(payload)
			requestId = payload.id

		case .tickSnapshotEnd:
			let payload = try  container.decode(TickSnapshotEnd.self)
			result = .success(payload)
			requestId = payload.id

		case .marketDataType:
			let payload = try  container.decode(CurrentMarketDataType.self)
			result = .success(payload)
			requestId = payload.id

		case .commissionAndFeesReport:
			let payload = try  container.decode(CommissionReport.self)
			result = .success(payload)
			requestId = nil

		case .positionSize:
			let payload = try  container.decode(PositionSize.self)
			result = .success(payload)
			requestId = nil

		case .positionSizeEnd:
			let payload = try  container.decode(PositionSizeEnd.self)
			result = .success(payload)
			requestId = nil

		case .displayGroupList:
			let payload = try  container.decode(DisplayGroupList.self)
			result = .success(payload)
			requestId = payload.id

		case .displayGroupUpdated:
			let payload = try  container.decode(DisplayGroupUpdate.self)
			result = .success(payload)
			requestId = payload.id

		case .positionMulti:
			let payload = try  container.decode(PositionSizeMulti.self)
			result = .success(payload)
			requestId = payload.id

		case .positionMultiEnd:
			let payload = try  container.decode(PositionSizeMultiEnd.self)
			result = .success(payload)
			requestId = payload.id

		case .securityDefinitionOptionParameter:
			let payload = try  container.decode(OptionContractDetails.self)
			result = .success(payload)
			requestId = payload.id

		case .securityDefinitionOptionParameterEnd:
			let payload = try  container.decode(OptionContractDetailsEnd.self)
			result = .success(payload)
			requestId = payload.id

		case .softDollarTiers:
			let payload = try  container.decode(SoftDollarTiers.self)
			result = .success(payload)
			requestId = payload.id

		case .familyCodes:
			let payload = try  container.decode(FamilyCodes.self)
			result = .success(payload)
			requestId = nil

		case .symbolSamples:
			let payload = try  container.decode(MatchingSymbols.self)
			result = .success(payload)
			requestId = payload.id

		case .mktDepthExchanges:
			let payload = try  container.decode(MarketDepthExchanges.self)
			result = .success(payload)
			requestId = nil

		case .tickReqParams:
			let payload = try  container.decode(TickReqParams.self)
			result = .success(payload)
			requestId = payload.id

		case .smartComponents:
			let payload = try  container.decode(ExchangeMap.self)
			result = .success(payload)
			requestId = payload.id

		case .newsArticle:
			let payload = try  container.decode(NewsArticle.self)
			result = .success(payload)
			requestId = payload.id

		case .tickNews:
			let payload = try  container.decode(TickNews.self)
			result = .success(payload)
			requestId = payload.id

		case .newsProviders:
			let payload = try  container.decode(NewsProviders.self)
			result = .success(payload)
			requestId = nil

		case .historicalNews:
			let payload = try  container.decode(HistoricalNews.self)
			result = .success(payload)
			requestId = payload.id

		case .historicalNewsEnd:
			let payload = try  container.decode(HistoricalNewsEnd.self)
			result = .success(payload)
			requestId = payload.id

		case .headTimestamp:
			let payload = try  container.decode(HeadTimestamp.self)
			result = .success(payload)
			requestId = payload.id

		case .histogramData:
			let payload = try  container.decode(HistogramDataUpdate.self)
			result = .success(payload)
			requestId = payload.id

		case .historicalDataUpdate:
			let payload = try  container.decode(HistoricalDataUpdate.self)
			result = .success(payload)
			requestId = payload.id

		case .marketRule:
			let payload = try  container.decode(MarketRule.self)
			result = .success(payload)
			requestId = payload.marketRuleId

		case .accountPNL:
			let payload = try  container.decode(AccountPNL.self)
			result = .success(payload)
			requestId = payload.id

		case .positionPNL:
			let payload = try  container.decode(PositionPNL.self)
			result = .success(payload)
			requestId = payload.id

		case .historicalTicks:
			let payload = try  container.decode(HistoricalTickData<HistoricalTick>.self)
			result = .success(payload)
			requestId = payload.id

		case .historicalTicksBidAsk:
			let payload = try  container.decode(HistoricalTickData<HistoricalTickBidAsk>.self)
			result = .success(payload)
			requestId = payload.id

		case .historicalTicksLast:
			let payload = try  container.decode(HistoricalTickData<HistoricalTickLast>.self)
			result = .success(payload)
			requestId = payload.id

		case .tickByTick:
			let payload = try  container.decode(TickByTickResponse.self)
			result = .success(payload)
			requestId = payload.id

		case .orderBound:
			let payload = try  container.decode(OrderBound.self)
			result = .success(payload)
			requestId = payload.orderId

		case .completedOrder:
			let payload = try  container.decode(CompletedOrder.self)
			result = .success(payload)
			requestId = payload.order.orderId

		case .completedOrdersEnd:
			let payload = try  container.decode(CompletedOrdersEnd.self)
			result = .success(payload)
			requestId = nil

		case .replaceFAEnd:
			let payload = try  container.decode(ReplaceFAEnd.self)
			result = .success(payload)
			requestId = payload.id

		case .wshMetaData:
			let payload = try  container.decode(WSHMetaData.self)
			result = .success(payload)
			requestId = payload.id

		case .wshEventData:
			let payload = try  container.decode(WSHEventDataResponse.self)
			result = .success(payload)
			requestId = payload.id

		case .historicalSchedule:
			let payload = try  container.decode(HistoricalSchedule.self)
			result = .success(payload)
			requestId = payload.id

		case .userInfo:
			let payload = try  container.decode(UserInfo.self)
			result = .success(payload)
			requestId = payload.id

		default:
			throw IBError.decodingError("unsopported message type \(decoder.description)")

		}
	
	}
	
		
	public func get() throws -> IBEvent {
		switch result {
		case .success(let object):
			return object
		case .failure(let error):
			throw error
		}
	}
		
	public var error: IBError? {
		switch result {
		case .failure(let error):
			return error
		default:
			return nil
		}
	}
		
}


extension Response {
	
	var id: Int {
		var hasher = Hasher()
		hasher.combine(requestId ?? type.origin?.rawValue)
		return hasher.finalize()
	}
	
}

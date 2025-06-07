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


public struct FundamentalDataRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .fundamentalData

	private let version:Int = 2
	
	private let minimumServerVersion: ServerVersion = .fundamentalData

	public let id: Int
	
	public let contract: Contract
	
	public enum ReportType: String, Codable, Sendable {
		case overview = "ReportSnapshot"
		case summary = "ReportsFinSummary"
		case ratios = "ReportRatios"
		case statements = "ReportsFinStatements"
		case estimates = "RESC"
		case calendar = "CalendarReport"
	}
	
	public let reportType: ReportType
	
	public let options: [String:String]?


	public init(id: Int, contract: Contract , reportType: ReportType) {
		self.id = id
		self.contract = contract
		self.reportType = reportType
		self.options = nil
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return FundamentalDataCancel(id: id)
	}

	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
			
		if encoder.serverVersion >= .tradingClass {
			try container.encodeOptional(contract.id)
		}
			
		try container.encodeOptional(contract.symbol)
		try container.encodeOptional(contract.type)
		try container.encodeOptional(contract.exchange)
		try container.encodeOptional(contract.primaryExchange)
		try container.encodeOptional(contract.currency)
		try container.encodeOptional(contract.localSymbol)
		
		try container.encode(reportType)
		
		if encoder.serverVersion >= .linking {
			try container.encodeOptional(options)
		}
	}
}


public struct FundamentalDataCancel: IdentifiableRequest {
	
	public let type: RequestType = .fundamentalDataCancel
	
	private let version:Int = 1
	
	private let minimumServerVersion: ServerVersion = .fundamentalData

	public let id: Int

	public init(id: Int){
		self.id = id
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
}




/**
 This function is called to receive fundamental
 market data. The appropriate market data subscription must be set
 up in Account Management before you can receive this data.
 */
public struct FundamentalData: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let xml: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.xml = try container.decode(String.self)
	}
	
}


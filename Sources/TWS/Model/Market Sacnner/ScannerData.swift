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





public struct ScannerSubscriptionRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public var type: RequestType = .scannerSubscription
	
	private let version:Int = 4

	public let id: Int
	
	public let subscription: ScannerSubscription
	
	public let scannerSubscriptionOptions: [String:String]?

	public let scannerSubscriptionFilterOptions: [String:String]?
	
	public init(
		id: Int,
		subscription: ScannerSubscription,
		scannerSubscriptionOptions: [String:String]? = nil,
		scannerSubscriptionFilterOptions: [String:String]? = nil
	) {
		self.id = id
		self.subscription = subscription
		self.scannerSubscriptionOptions = scannerSubscriptionOptions
		self.scannerSubscriptionFilterOptions = scannerSubscriptionFilterOptions
	}
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		return ScannerSubscriptionCancel(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
		try container.encode(type)
			
		if encoder.serverVersion < .scannerGenericOpts {
			try container.encode(version)
		}
			
		try container.encode(id)
		try container.encode(subscription.numberOfRows)
		try container.encode(subscription.instrument)
		try container.encode(subscription.locationCode)
		try container.encode(subscription.scanCode)
			
		try container.encode(subscription.abovePrice)
		try container.encode(subscription.belowPrice)
		try container.encode(subscription.aboveVolume)
		try container.encode(subscription.marketCapAbove)
		try container.encode(subscription.marketCapBelow)
		try container.encode(subscription.moodyRatingAbove)
		try container.encode(subscription.moodyRatingBelow)
		try container.encode(subscription.spRatingAbove)
		try container.encode(subscription.spRatingBelow)
		try container.encode(subscription.maturityDateAbove)
		try container.encode(subscription.maturityDateBelow)
		try container.encode(subscription.couponRateAbove)
		try container.encode(subscription.couponRateBelow)
		try container.encode(subscription.excludeConvertible)
			
		if encoder.serverVersion.rawValue >= 25 {
			try container.encode(subscription.averageOptionVolumeAbove)
			try container.encode(subscription.scannerSettingPairs)
		}
			
		if encoder.serverVersion.rawValue >= 27 {
			try container.encode(subscription.stockTypeFilter)
		}
			
		if encoder.serverVersion >= .scannerGenericOpts {
			try container.encode(scannerSubscriptionFilterOptions)
		}
		
		if encoder.serverVersion >= .linking {
			try container.encode(scannerSubscriptionOptions)
		}
	
	}
}


public struct ScannerSubscriptionCancel: IdentifiableRequest{
	
	public let type: RequestType = .scannerSubscriptionCancel

	private let version:Int = 1
	
	public let id: Int
	
	init(id: Int) {
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
 Provides the data resulting from the market scanner request.

 reqid - the request's identifier.
 rank -  the ranking within the response of this bar.
 contractDetails - the data's ContractDetails
 distance -      according to query.
 benchmark -     according to query.
 projection -    according to query.
 legStr - describes the combo legs when the scanner is returning EFP
 */
public struct ScannerData:  IBEvent, IBDecodable, Identifiable {
		
	public let id: Int
	
	public struct ScannerResult: Sendable, Decodable {
		public let rank: Int
		public let distance: String
		public let benchmark: String
		public let projection: String
		public let legsStr: String
		
		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.rank = try container.decode(Int.self)
			self.distance = try container.decode(String.self)
			self.benchmark = try container.decode(String.self)
			self.projection = try container.decode(String.self)
			self.legsStr = try container.decode(String.self)
		}
		
	}
		
	public let result: [ContractDetails:ScannerResult]
	
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		
		let count = try container.decode(Int.self)
		var buffer:[ContractDetails:ScannerResult] = [:]
		for _ in 0..<count {
			
			var details = ContractDetails()
			details.id = try container.decode(Int.self)
			details.symbol = try container.decode(String.self)
			details.type = try container.decode(SecuritiesType.self)
			details.expiration = try container.decodeOptional(DateComponents.self)
			details.strike = try container.decodeOptional(Double.self)
			details.right = try container.decodeOptional(Contract.ExecutionRight.self)
			details.currency = try container.decode(String.self)
			details.localSymbol = try container.decode(String.self)
			details.marketName = try container.decode(String.self)
			details.tradingClass = try container.decodeOptional(String.self)
						
			let filter = try container.decodeOptional(ScannerResult.self)

			buffer[details] = filter
			
		}
		
		result = buffer
	}
	
}

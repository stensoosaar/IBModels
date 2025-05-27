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
 Wall Street Horizon Corporate Event filter
 */
public struct WSHEventData: Sendable {
	public var id: Int?
	public var filter: String?
	public var fillWatchlist: Bool = false
	public var fillPortfolio: Bool = false
	public var fillCompetitors: Bool = false
	public var startDate: Date?
	public var endDate: Date?
	public var totalLimit: Int?
}


public struct WSHEventDataRequest: AnyCancellableRequest, IdentifiableRequest {
	
	public let type: RequestType = .wshEventData
	
	private let minimumServerVersion: ServerVersion = .wshEventDataFilters
	
	public let id: Int
	
	public let wshEventData: WSHEventData
	
	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		WSHEventDataCancel(id: id)
	}
	
	public init(id: Int, wshEventData: WSHEventData){
		self.id = id
		self.wshEventData = wshEventData
	}
	
	public func encode(to encoder: IBEncoder) throws {
				
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(wshEventData.id)
		
		if encoder.serverVersion >= .wshEventDataFilters {
			try container.encode(wshEventData.filter)
			try container.encode(wshEventData.fillWatchlist)
			try container.encode(wshEventData.fillPortfolio)
			try container.encode(wshEventData.fillCompetitors)
		}
		
		if encoder.serverVersion >= .wshEventDataFiltersDate {
			try container.encode(wshEventData.startDate)
			try container.encode(wshEventData.endDate)
			try container.encodeOptional(wshEventData.totalLimit)
		}
	}
	
}


public struct WSHEventDataCancel: IdentifiableRequest {
	
	public let type: RequestType = .wshEventDataCancel
	
	private let minimumServerVersion: ServerVersion = .wsheCalendar
	
	public let id: Int
	
	public init(id: Int){
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
}



public struct WSHEventDataResponse: IBEvent, IBDecodable, Identifiable {

	public let id: Int

	public let json: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.json = try container.decode(String.self)
	}
	
}

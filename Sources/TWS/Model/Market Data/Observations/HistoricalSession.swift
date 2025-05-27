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
 returns historical schedule for historical data request with whatToShow=SCHEDULE
 */
public struct HistoricalSchedule: IBEvent, IBDecodable, Identifiable{

	public let id: Int

	public let start: String

	public let end: String

	public let timeZoneID: String
	
	public struct HistoricalSession: Sendable, Decodable {
		public var start: String
		public var end: String
		public var referencedate: String
		
		public init(from decoder: any Decoder) throws{
			var container = try decoder.unkeyedContainer()
			self.start = try container.decode(String.self)
			self.end = try container.decode(String.self)
			self.referencedate = try container.decode(String.self)
		}
		
	}

	public let sessions: [HistoricalSession]
	
	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.start = try container.decode(String.self)
		self.end = try container.decode(String.self)
		self.timeZoneID = try container.decode(String.self)
		let count = try container.decode(Int.self)
		var buffer:[HistoricalSession] = []
		for _ in 0..<count{
			let temp = try container.decode(HistoricalSession.self)
			buffer.append(temp)
		}
		sessions = buffer

	}

	
}

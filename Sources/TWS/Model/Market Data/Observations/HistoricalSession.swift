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
 Delivers historical schedule  request with whatToShow=SCHEDULE
 */
public struct HistoricalSchedule: IBEvent, IBDecodable, Identifiable{

	/// id of orginating request
	public let id: Int

	/// Response range
	public let interval: DateInterval

	/// the time zone referenced by the schedule
	public let timeZoneID: String
	
	public struct HistoricalSession: Sendable, Decodable {
		public let interval: DateInterval
		public let referenceDate: String
		
		public init(from decoder: any Decoder) throws{
			var container = try decoder.unkeyedContainer()
			let start = try container.decode(Date.self)
			let end = try container.decode(Date.self)
			self.interval = DateInterval(start: start, end: end)
			self.referenceDate = try container.decode(String.self)
		}
		
	}

	public let sessions: [HistoricalSession]
	
	public init(from decoder: IBDecoder) throws{
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		let start = try container.decode(String.self)
		let end = try container.decode(String.self)
		self.interval = DateInterval(start: start, end: end)
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

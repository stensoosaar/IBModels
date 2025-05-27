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


public struct TradingCalendar: IBDecodable, Sendable {
	
	public var timeZone: TimeZone

	/**
	 The trading hours of the product.
	 This value will contain the trading hours of the current day as well as the next’s.
	 */
	public var regularSessions: [DateInterval]
	
	/**
	 The liquid hours of the product.
	 This value will contain the liquid hours (regular trading hours) of the contract on the specified exchange.
	 */

	public var extendedSessions: [DateInterval]

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let timeZoneID = try container.decode(String.self)
		let extended = try container.decode(String.self).components(separatedBy: ";")
		let regular = try container.decode(String.self).components(separatedBy: ";")

		guard let timeZone = TimeZone(identifier: timeZoneID) ?? TimeZone(deprecatedName: timeZoneID) else {
			throw IBError.decodingError("Unknown time zone ID: \(timeZoneID)")
		}

		let formatter = DateFormatter()
		formatter.timeZone = timeZone
		formatter.dateFormat = "yyyyMMdd:HHmm"

		func parseSession(_ string: String) -> DateInterval? {
			guard let range = string.range(of: "-") else { return nil }
			let startString = String(string[string.startIndex..<range.lowerBound])
			let endString = String(string[range.upperBound...])
			guard let start = formatter.date(from: startString),
				let end = formatter.date(from: endString) else {
				return nil
			}
			return DateInterval(start: start, end: end)
		}

		self.timeZone = timeZone
		self.regularSessions = regular.compactMap(parseSession)
		self.extendedSessions = extended.compactMap(parseSession)
		
	}
	
	
	
}

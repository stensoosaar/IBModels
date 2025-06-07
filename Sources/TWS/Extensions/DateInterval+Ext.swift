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


public extension DateInterval {
	
	
	/**
	 Creates back looking dateinterval
	 - parameter value: The number of time units to look back.
	 - parameter unit: The calendar component representing the unit of time (e.g. `.day`, `.month`, `.year`).
	 - parameter endDate: The end date of the interval. Defaults to the current datetime.
	 
	 Example, returning the last 7 days ending now
	 ```swift
	 let lastWeek = DateInterval.lookback(7, unit: .day)
	 ```
	*/
	static func lookback(_ value: Int, unit: Calendar.Component, until endDate: Date = Date()) -> DateInterval {
		let adjustedEnd = endDate.timeIntervalSince1970 > Date().timeIntervalSince1970 ? Date() : endDate
		let startDate = Calendar.utc.date(byAdding: unit, value: -1 * abs(value), to: adjustedEnd)!
		return DateInterval(start: startDate.startOfDay, end: endDate)
	}
	
	
	func contains(date: Date?) -> Bool {
		guard let date = date else { return false}
		return self.contains(date)
	}
	
	func strideThrough(by timeInterval: TimeInterval) -> StrideThrough<TimeInterval> {
		return stride(
			from: self.start.timeIntervalSince1970,
			through: self.end.timeIntervalSince1970,
			by: timeInterval
		)
	}
	
	func strideTo(by timeInterval: TimeInterval) -> StrideTo<TimeInterval> {
		return stride(
			from: self.start.timeIntervalSince1970,
			to: self.end.timeIntervalSince1970,
			by: timeInterval
		)
	}
	
	var twsDescription: String {
		
		let adjustedEnd = end.timeIntervalSince1970 > Date().timeIntervalSince1970 ? Date() : end
		let adjustedDuration = adjustedEnd.timeIntervalSince1970 - start.timeIntervalSince1970
							
		switch adjustedDuration {
			
		case 0..<86400:
			return String(format: "%d S", Int(adjustedDuration))
		case 86400..<2678400:
			return String(format: "%d D", Int(adjustedDuration/86400))
		case 2678400..<31536000:
			return String(format: "%d M", Int(adjustedDuration/2678400))
		default:
			return String(format: "%d Y", Int(adjustedDuration/31536000))
		}
	
	}
	
	var twsDescriptionLong: String {
		
		let adjustedEnd = end.timeIntervalSince1970 > Date().timeIntervalSince1970 ? Date() : end
		let adjustedDuration = adjustedEnd.timeIntervalSince1970 - start.timeIntervalSince1970
							
		switch adjustedDuration {
			
		case 0..<86400:
			return String(format: "%d seconds", Int(adjustedDuration))
		case 86400..<2678400:
			return String(format: "%d days", Int(adjustedDuration/86400))
		case 2678400..<31536000:
			return String(format: "%d months", Int(adjustedDuration/2678400))
		default:
			return String(format: "%d year", Int(adjustedDuration/31536000))
		}
	
	}
	
}

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



public struct IBError: Error {
	public let date: Date
	public let code: Int
	public let message: String
	public let orderRejectReason: String?
}


extension IBError: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()

		self.code   = try container.decode(Int.self)

		let message = try container.decode(String.self)
		if decoder.serverVersion >= ServerVersion.encodeMsgAscii7 {
			// decodeUnicodeEscapedString message
		}
		self.message = message

		let rejection = try container.decodeOptional(String.self)
		if decoder.serverVersion >= ServerVersion.advancedOrderReject {
			// decodeUnicodeEscapedString rejection
		}
		orderRejectReason = rejection

		if decoder.serverVersion >= ServerVersion.errorTime {
			let timestamp = try container.decode(Double.self)
			self.date = Date(timeIntervalSince1970: timestamp/1000)
		} else {
			self.date = Date()
		}
	}
	
}


extension IBError {
	
	public static func decodingError(_ reason: String) -> IBError{
		return .init(date: Date(), code: 0, message: reason, orderRejectReason: nil)
	}

	public static func encodingError(_ reason: String) -> IBError{
		return .init(date: Date(), code: 0, message: reason, orderRejectReason: nil)
	}
	
	public static func invalidValue(_ reason: String) -> IBError{
		return .init(date: Date(), code: 0, message: reason, orderRejectReason: nil)
	}
	
}



public struct ErrorMessage: IBDecodable {

	public let id: Int

	public let error: IBError

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		if decoder.serverVersion < .errorTime {
			_ = try container.decode(Int.self)
		}
		self.id = try container.decode(Int.self)
		self.error = try container.decode(IBError.self)
	}
	
}


/*
 MIT License

 Created by Szymon Lorenz on 16/2/2025.
 
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




/// A generic wrapper for decoding values that might be an `Int`, `Double`, or `String`
/// and ensures graceful handling of missing or malformed data.
///
/// - Supports decoding `Int`, `Double`, and `String` values.
/// - Defaults to `.missing` if the value cannot be converted.
/// - Provides `.unwrapped` for optional access or `.orZero` for a safe default.
///
/// Example Usage:
/// ```swift
/// let size = try container.decode(DecodableValue<Double>.self).orZero
/// let mask = try container.decode(DecodableValue<Int>.self).orZero
/// ```

struct DecodableValue<T: LosslessStringConvertible>: Decodable {
	
	/// The decoded value or a `.missing` case if decoding failed.
	private var value: T?

	/// Attempts to decode an `Int`, `Double`, or `String` from the decoder.
	/// - Parameter decoder: The decoder to extract the value from.
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		// Try decoding as an Int first, then convert to the desired type
		if let intValue = try? container.decode(Int.self), let converted = T("\(intValue)") {
			value = converted
		}
		// Try decoding as a Double, then convert
		else if let doubleValue = try? container.decode(Double.self), let converted = T("\(doubleValue)") {
			value = converted
		}
		// Try decoding as a String, then convert
		else if let stringValue = try? container.decode(String.self), let converted = T(stringValue) {
			value = converted
		}
		// If all attempts fail, keep value as nil (missing)
		else {
			value = nil
		}
	}

	/// Retrieves the unwrapped value if available, otherwise returns `nil`.
	var unwrapped: T? {
		return value
	}
	
	/// Retrieves the unwrapped value, or returns `0` if the value is missing.
	/// - Note: Assumes `T` can be initialized with `"0"`, which is safe for numeric types like `Int` and `Double`.
	var orZero: T {
		return value ?? T("0")!
	}
}

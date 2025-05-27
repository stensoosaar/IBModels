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

struct BitMask: Decodable {
	
	private var rawValue: Int
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(Int.self)
	}
	
	func get(_ index: Int) -> Bool {
		return rawValue & (1 << index) != 0
	}
	
	mutating func set(index:Int, element: Bool) -> Bool {
		let res = get(index)
		if element{
			rawValue |= 1 << index
		} else {
			rawValue &= ~(1 << index)
		}
		return res
	}
	
	mutating func clear(){
		rawValue = 0
	}
	
	func getMask() -> Int {
		return rawValue
	}
	
}

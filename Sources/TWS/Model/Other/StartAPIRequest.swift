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
 Creates a request to start API
 
 Should be sent after handshake response
 - returns: `NextRequestID`, `ManagedAccounts` and optionally `OpenOrders` messages (if you have any)
 - parameter clientId: your app identifier.
 - parameter options: some
 - important: Calls made prior receiving `NextRequestID` could be dropped
 */

public struct StartAPIRequest: AnyRequest{
	
	public let type: RequestType = .startAPI
	
	private let version: Int = 2
	
	public let clientId: Int
	
	public let options: String?
	
	public init(clientId: Int, options: String? = nil){
		self.clientId = clientId
		self.options = options
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(clientId)
		
		if encoder.serverVersion >= .optionalCapabilities {
			try container.encodeOptional(options)
		}
	}
	
}

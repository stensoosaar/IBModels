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




public struct GroupEventsRequest: AnyCancellableRequest, IdentifiableRequest {
	
	private let version:Int = 1

	public let type: RequestType = .subscribeToGroupEvents
	
	private let minimumServerVersion: ServerVersion = .linking

	public let id: Int

	public let groupId: Int

	/// The corresponding cancellation request for this subscription.
	public var cancel: any AnyRequest{
		GroupEventsCancel(id: id)
	}
	
	public init(id: Int, groupId: Int){
		self.id = id
		self.groupId = groupId
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(groupId)
	}
}


public struct GroupEventsCancel: IdentifiableRequest, Identifiable{
	
	private let version:Int = 1

	public let type: RequestType = .unsubscribeFromGroupEvents
	
	private let minimumServerVersion: ServerVersion = .linking

	public let id: Int


	public init(id: Int){
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
}




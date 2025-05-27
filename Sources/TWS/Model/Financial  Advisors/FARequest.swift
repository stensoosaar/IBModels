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


public enum FADataType: Int, Sendable, Codable{
	case groups = 1
	case aliases = 3
}



public struct FARequest: AnyRequest {
	
	public let type: RequestType = .advisor

	private let version:Int = 1
	
	private let minimumServerVersion: ServerVersion = .FAProfileDesupport

	public enum DataType: Int, Codable, Sendable {
		case groups = 1
		case aliases = 3
	}
	
	public let faDataType: DataType

	public init(faDataType: DataType){
		self.faDataType = faDataType
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(faDataType)
	}
}

/**
 receives the Financial Advisor's configuration available in the TWS

 faDataType - one of:
	 Groups: offer traders a way to create a group of accounts and apply
		  a single allocation method to all accounts in the group.
	 Account Aliases: let you easily identify the accounts by meaningful
		  names rather than account numbers.
 faXmlData -  the xml-formatted configuration
 */
public struct ReceiveFA:  IBEvent, IBDecodable {

	public let faData: FADataType

	public let xml: String

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		faData = try container.decode(FADataType.self)
		xml = try container.decode(String.self)
	}
}




public struct ReplaceFARequest: IdentifiableRequest {
	
	public let type: RequestType = .advisorReplace

	private let version:Int = 1

	private let minimumServerVersion: ServerVersion = .FAProfileDesupport

	public let id: Int
	
	public enum DataType: Int, Codable, Sendable {
		case groups = 1
		case aliases = 3
	}
	
	public let faDataType: DataType
	
	public let xml:String
	
	public init(id: Int, faDataType: DataType,  xml:String ){
		self.id = id
		self.faDataType = faDataType
		self.xml = xml
	}
	
	public func encode(to encoder: IBEncoder) throws {
	
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode(faDataType)
		try container.encode(xml)
		if encoder.serverVersion >= .replaceFAEnd {
			try container.encode(id)
		}
	}
}


/**
 This is called at the end of a replace FA.
 */
public struct ReplaceFAEnd: IBEvent, IBDecodable{

	public let id: Int

	public let text: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.text = try container.decode(String.self)
	}
	
}

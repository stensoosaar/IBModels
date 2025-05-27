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
 Request for news articles
 
 After requesting news headlines using one of the above functions, the body of a news article can be requested with the article ID
 */

public struct NewsArticleRequest: IdentifiableRequest {
	
	public let type: RequestType = .newsArticle
	
	private let minimumServerVersion: ServerVersion = .reqNewsArticle

	public let id: Int

	public let providerCode: String
	
	public let articleId: String
	
	public let options: [String: String]?
	
	/**
	 - parameter id: unique request id
	 - parameter providerCode: Short code indicating news provider, e.g. FLY.
	 - parameter articleId: Article id, obtained from headlines
	 */
	public init(
		id: Int,
		providerCode: String,
		articleId: String,
	){
		self.id = id
		self.providerCode = providerCode
		self.articleId = articleId
		options = nil
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(providerCode)
		try container.encode(articleId)
			
		if encoder.serverVersion >= .newsQueryOrigins {
			try container.encode(options)
		}
	}
}



/**
 Delivers news article content
*/
public struct NewsArticle: IBEvent, IBDecodable, Identifiable{

	/// origintated request id
	public let id: Int

	public enum ArticleType:Int, Decodable, Sendable{
		case plain = 0
		case binary = 1
	}

	/// content type
	public let type: ArticleType

	/// article body
	public let content: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try  decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.type = try container.decode(ArticleType.self)
		self.content = try container.decode(String.self)
	}
}


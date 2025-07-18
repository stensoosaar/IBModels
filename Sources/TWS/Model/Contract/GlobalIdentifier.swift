//
//  GlobalIdentifier.swift
//  IBModels
//
//  Created by Sten Soosaar on 18.07.2025.
//

import Foundation


/**
 Represents a globally recognized identifier for a financial instrument or security for the purposes of facilitating clearing and settlement of trades
 
 A `GlobalIdentifier` combines a provider type (such as ISIN, CUSIP, SEDOL, RIC, or FIGI) with an identifier value
 to uniquely identify a security across international markets. This struct supports coding, equality,
 and safe concurrent usage.
*/

public struct GlobalIdentifier: Codable, Sendable, Equatable {
	
	/**
	 Represents the organization or system that issues a global financial identifier for a security or asset.
	 Common providers include ISIN, CUSIP, SEDOL, RIC, and FIGI.
	*/
	public enum Provider: String, Codable, Sendable {
		
		/// International Securities Identification Number
		case isin = "ISIN"
		
		/// North American financial security
		case cusip = "CUSIP"
		
		/// Stock Exchange Daily Official List, a list of security identifiers used in the United Kingdom and Ireland.
		case sedol = "SEDOL"
		
		// Reuters identification code
		case ric = "RIC"
		
		/// Financial Instrument Global Identifier (FIGI) (formerly Bloomberg Global Identifier (BBGID))
		/// is an open standard, unique identifier of financial instruments that can be assigned to instruments
		case figi = "FIGI"
	}

	/// ID provider organisation like ISIN, Reuters, Bloomberg etc
	public let type: Provider
	
	// identifier value
	public let identifier: String
	
	public static func == (lhs: GlobalIdentifier, rhs: GlobalIdentifier) -> Bool {
		return lhs.type == rhs.type && lhs.identifier == rhs.identifier
	}
	
	public init(_ id: String, type: Provider){
		self.type = type
		self.identifier = id
	}
	
	//TODO: - need to encode empty values if empty
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encodeOptional(self.type)
		try container.encodeOptional(self.identifier)
	}
	
	public init(from decoder: IBDecoder) throws {
		var container  = try decoder.unkeyedContainer()
		self.type = try container.decode(Provider.self)
		self.identifier = try container.decode(String.self)
	}
	
}
	


//
//  MarketDepthMessage.swift
//  IBModels
//
//  Created by Sten Soosaar on 25.05.2025.
//


import Foundation


/**
 Represents an Contract's order book
 */

public protocol AnyMarketDepth: IBEvent, IBDecodable {
	
	/// the order book's row being updated
    var row: Int { get }
	
	/// how to refresh the row
    var operation: OperationType { get }
	
	/// quote side
    var side: QuoteSide { get }
	
	/// quoted price and size
    var quote: Quote { get }
	
}

//
//  AnyBar.swift
//  IBModels
//
//  Created by Sten Soosaar on 18.05.2025.
//

import Foundation

public protocol AnyBar {
			
	/// observation start date
	var date: Date {get}
		
	/// observation first price
	var open: Double {get}
		
	/// observation max value
	var high: Double {get}
		
	/// observation min value
	var low: Double {get}
		
	// observation last value
	var close: Double {get}
		
	///The bar’s traded volume if available
	/// - note: only available for TRADES
	var volume: Double? {get}
		
	///The bar’s Weighted Average Price
	/// - note: only available for TRADES
	var vwap: Double? {get}
		
	///The number of trades during the bar’s timespan
	/// - note: only available for TRADES
	var count: Int? {get}
	
}

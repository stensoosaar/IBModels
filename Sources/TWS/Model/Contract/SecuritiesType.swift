//
//  SecuritiesType.swift
//  IBModels
//
//  Created by Sten Soosaar on 18.07.2025.
//

import Foundation

public enum SecuritiesType: String, Sendable, Codable {
	
	/// Stock (e.g., common or preferred equity).
	case stock = "STK"
	
	/// Option on stocks or indices.
	case option = "OPT"
	
	/// Standardized futures contract.
	case future = "FUT"
	
	/// Continuous future — a synthetic representation of rolling futures.
	case continousFuture = "CONTFUT"
	
	/// Cash instrument — typically foreign exchange.
	case cash = "CASH"
	
	/// Fixed-income security such as government or corporate bonds.
	case bond = "BOND"
	
	/// Contract for Difference — derivative instrument.
	case cfd = "CFD"
	
	/// Option on a futures contract.
	case futuresOption = "FOP"
	
	/// Warrant — long-dated option typically issued by a company.
	case warrant = "WAR"
	
	/// Structured product such as barrier or digital options.
	case structuredProduct = "IOPT"
	
	/// Forward contract — customized OTC agreement.
	case forward = "FWD"
	
	/// Combination of multiple instruments (e.g., option spread).
	case combo = "BAG"
	
	/// Market index (e.g., S&P 500, Nasdaq).
	case index = "IND"
	
	/// Treasury bill — short-term government security.
	case bill = "BILL"
	
	/// Mutual fund or exchange-traded fund (ETF).
	case fund = "FUND"
	
	/// Fixed income instrument not covered under bond or bill.
	case fixed = "FIXED"
	
	/// Securities lending/borrowing instrument.
	case slb = "SLB"
	
	/// News feed — not a tradable instrument.
	case news = "NEWS"
	
	/// Commodity such as gold, oil, or agricultural products.
	case commodity = "CMDTY"
	
	/// Basket of securities.
	case bsk = "BSK"
	
	/// Intercommodity unit — related to futures spreads.
	case icu = "ICU"
	
	/// Intercommodity spread.
	case ics = "ICS"
	
	/// Cryptocurrency asset (e.g., BTC, ETH).
	case crypto = "CRYPTO"
}

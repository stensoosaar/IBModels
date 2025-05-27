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
 Identifies keys for Account Summary value
 */
public enum AccountSummaryKeys: String, Codable, CaseIterable, Sendable {
	
	/// Identifies the IB account structure
	case accountType = "AccountType"
	
	/// The basis for determining the price of the assets in your account.
	/// Total cash value + stock value + options value + bond value
	case netLiquidation = "NetLiquidation"
	
	/// Total cash balance recognized at the time of trade + futures PNL
	case totalCashValue = "TotalCashValue"
	
	/// Cash recognized at the time of settlement
	/// purchases at the time of trade - commissions - taxes - fees
	case settledCash = "SettledCash"
	
	/// Total accrued cash value of stock, commodities and securities
	case accruedCash = "AccruedCash"
	
	/// Buying power serves as a measurement of the dollar value of securities that one may purchase in a securities account without depositing additional funds
	case buyingPower = "BuyingPower"
	
	/// Forms the basis for determining whether a client has the necessary assets to either initiate or maintain security positions.
	/// Cash + stocks + bonds + mutual funds
	case equityWithLoanValue = "EquityWithLoanValue"
	
	/// Marginable Equity with Loan value as of 16:00 ET the previous day
	case previousEquityWithLoanValue = "PreviousEquityWithLoanValue"
	
	/// The sum of the absolute value of all stock and equity option positions
	case grossPositionValue = "GrossPositionValue"
	
	/// Regulation T equity for universal account
	case regTEquity = "RegTEquity"
	
	/// Regulation T margin for universal account
	case regTMargin  = "RegTMargin"
	
	/// Special Memorandum Account
	/// Line of credit created when the market value of securities in a Regulation T account increase in value
	case sma = "SMA"
	
	/// Initial Margin requirement of whole portfolio
	case initMarginReq = "InitMarginReq"
	
	/// Maintenance Margin requirement of whole portfolio
	case maintMarginReq = "MaintMarginReq"
	
	/// This value tells what you have available for trading
	case availableFunds = "AvailableFunds"
	
	/// This value shows your margin cushion, before liquidation
	case excessLiquidity = "ExcessLiquidity"
	
	/// Excess liquidity as a percentage of net liquidation value
	case cushion = "Cushion"
	
	/// Initial Margin of whole portfolio with no discounts or intraday credits
	case fullInitMarginReq = "FullInitMarginReq"
	
	/// Maintenance Margin of whole portfolio with no discounts or intraday credits
	case fullMaintMarginReq = "FullMaintMarginReq"
	
	/// Available funds of whole portfolio with no discounts or intraday credits
	case fullAvailableFunds = "FullAvailableFunds"
	
	/// Excess liquidity of whole portfolio with no discounts or intraday credits
	case fullExcessLiquidity = "FullExcessLiquidity"
	
	/// Time when look-ahead values take effect
	case lookAheadNextChange = "LookAheadNextChange"
	
	/// Initial Margin requirement of whole portfolio as of next period's margin change
	case lookAheadInitMarginReq = "LookAheadInitMarginReq"
	
	/// Maintenance Margin requirement of whole portfolio as of next period's margin change
	case lookAheadMaintMarginReq = "LookAheadMaintMarginReq"
	
	/// This value reflects your available funds at the next margin change
	case lookAheadAvailableFunds = "LookAheadAvailableFunds"
	
	/// This value reflects your excess liquidity at the next margin change
	case lookAheadExcessLiquidity = "LookAheadExcessLiquidity"
	
	/// A measure of how close the account is to liquidation
	case highestSeverity = "HighestSeverity"
	
	/// The Number of Open/Close trades a user could put on before Pattern Day Trading is detected.
	/// A value of "-1" means that the user can put on unlimited day trades.
	case dayTradesRemaining = "DayTradesRemaining"
	
	/// GrossPositionValue / NetLiquidation
	case leverage = "Leverage"
	

}


extension AccountSummaryKeys: CustomStringConvertible {
	public var description: String {
		return self.rawValue
	}
}


extension AccountSummaryKeys {
	
	var valueType: Decodable.Type {
		switch self {
		case .accountType: return String.self
		default: return Double.self
		}
	}
		
	public var margin: [Self]{
		return [
			.regTEquity,
			.regTMargin,
			.initMarginReq,
			.maintMarginReq,
			.fullInitMarginReq,
			.fullMaintMarginReq,
			.fullAvailableFunds,
			.fullExcessLiquidity,
			.lookAheadNextChange,
			.lookAheadInitMarginReq,
			.lookAheadMaintMarginReq,
			.cushion
		]
	}
	
	/// request all cash balances in base currency
	public static var balancesInBaseCurrency: [String]{
		return ["$LEDGER"]
	}

	/// request all cash balances in specified currency
	public static func balancesIn(currency: String) -> [String]{
		return ["$LEDGER:\(currency.uppercased())"]
	}
	
	public static var balancesInAllCurrencies: [String]{
		return ["$LEDGER:ALL"]
	}
	
}

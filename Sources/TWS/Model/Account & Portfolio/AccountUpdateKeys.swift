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
 Identifies keys for Account Update event value
 */
public enum AccountUpdateKeys: String, CaseIterable, Codable, Sendable {
	
	/// The account ID number
	case accountCode = "AccountCode"

	/// "All" to return account summary data for all accounts, or set to a specific Advisor Account Group name that has already been created in TWS Global Configuration
	case accountOrGroup = "AccountOrGroup"

	/// For internal use only
	case accountReady = "AccountReady"

	/// Identifies the IB account structure
	case accountType = "AccountType"

	/// Total accrued cash value of stock, commodities and securities
	case accruedCash = "AccruedCash"

	/// Reflects the current's month accrued debit and credit interest to date, updated daily in commodity segment
	case accruedCashCommodities  = "AccruedCash-C"

	/// Reflects the current's month accrued debit and credit interest to date, updated daily in security segment
	case accruedCashSecurities = "AccruedCash-S"

	/// Total portfolio value of dividends accrued
	case accruedDividend = "AccruedDividend"

	/// Dividends accrued but not paid in commodity segment
	case accruedDividendCommodities = "AccruedDividend-C"

	/// Dividends accrued but not paid in security segment
	case accruedDividendSecurities = "AccruedDividend-S"

	/// This value tells what you have available for trading
	case availableFunds = "AvailableFunds"

	/// Net Liquidation Value - Initial Margin
	case availableFundsCommodities = "AvailableFunds-C"

	/// Equity with Loan Value - Initial Margin
	case availableFundsSecurities = "AvailableFunds-S"

	/// Total portfolio value of treasury bills
	case billable = "Billable"

	/// Value of treasury bills in commodity segment
	case billableCommodities = "Billable-C"

	/// Value of treasury bills in security segment
	case billableSecurities = "Billable-S"

	/// Account buying power
	///
	/// Cash Account: Minimum (Equity with Loan Value, Previous Day Equity with Loan Value)-Initial Margin,
	/// Standard Margin Account: Minimum (Equity with Loan Value, Previous Day Equity with Loan Value) - Initial Margin *4
	case buyingPower = "BuyingPower"

	/// Cash recognized at the time of trade + futures PNL
	case cashBalance = "CashBalance"

	/// Value of non-Government bonds such as corporate bonds and municipal bonds
	case corporateBondValue = "CorporateBondValue"

	/// Open positions are grouped by currency
	case currency = "Currency"

	/// Excess liquidity as a percentage of net liquidation value
	case cushion = "Cushion"

	/// Number of Open/Close trades one could do before Pattern Day Trading is detected
	case dayTradesRemaining = "DayTradesRemaining"

	/// Number of Open/Close trades one could do tomorrow before Pattern Day Trading is detected
	case dayTradesRemainingT1 = "DayTradesRemainingT+1"

	/// Number of Open/Close trades one could do two days from today before Pattern Day Trading is detected
	case dayTradesRemainingT2 = "DayTradesRemainingT+2"

	/// Number of Open/Close trades one could do three days from today before Pattern Day Trading is detected
	case dayTradesRemainingT3 =  "DayTradesRemainingT+3"

	/// Number of Open/Close trades one could do four days from today before Pattern Day Trading is detected
	case dayTradesRemainingT4 = "DayTradesRemainingT+4"

	/// Forms the basis for determining whether a client has the necessary assets to either initiate or maintain security positions
	case equityWithLoanValue = "EquityWithLoanValue"

	/// EquityWithLoanValue for Commodities segment
	/// Cash account: Total cash value + commodities option value - futures maintenance margin requirement + minimum (0, futures PNL)
	/// Margin account: Total cash value + commodities option value - futures maintenance margin requirement
	case equityWithLoanValueCommodities = "EquityWithLoanValue-C"

	/// Cash account: Settled Cash
	/// Margin Account: Total cash value + stock value + bond value + (non-U.S. & Canada securities options value)
	case equityWithLoanValueSecurities = "EquityWithLoanValue-S"

	/// This value shows your margin cushion, before liquidation
	case excessLiquidity = "ExcessLiquidity"

	/// Equity with Loan Value - Maintenance Margin
	case excessLiquidityCommodities = "ExcessLiquidity-C"

	/// Net Liquidation Value - Maintenance Margin
	case excessLiquiditySecurities = "ExcessLiquidity-S"

	/// The exchange rate of the currency to your base currency
	case exchangeRate = "ExchangeRate"

	/// Available funds of whole portfolio with no discounts or intraday credits
	case fullAvailableFunds = "FullAvailableFunds"

	/// Net Liquidation Value - Full Initial Margin
	case fullAvailableFundsC = "FullAvailableFunds-C"

	/// Equity with Loan Value - Full Initial Margin
	case fullAvailableFundsSecurities = "FullAvailableFunds-S"

	/// Excess liquidity of whole portfolio with no discounts or intraday credits
	case fullExcessLiquidity = "FullExcessLiquidity"

	/// Net Liquidation Value - Full Maintenance Margin
	case fullExcessLiquidityCommodities = "FullExcessLiquidity-C"

	/// Equity with Loan Value - Full Maintenance Margin
	case fullExcessLiquiditySecurities = "FullExcessLiquidity-S"

	/// Initial Margin of whole portfolio with no discounts or intraday credits
	case fullInitMarginReq = "FullInitMarginReq"

	/// Initial Margin of commodity segment's portfolio with no discounts or intraday credits
	case fullInitMarginReqCommodities = "FullInitMarginReq-C"

	/// Initial Margin of security segment's portfolio with no discounts or intraday credits
	case fullInitMarginReqSecurities = "FullInitMarginReq-S"

	/// Maintenance Margin of whole portfolio with no discounts or intraday credits
	case fullMaintMarginReq = "FullMaintMarginReq"

	/// Maintenance Margin of commodity segment's portfolio with no discounts or intraday credits
	case fullMaintMarginReqCommodities = "FullMaintMarginReq-C"

	/// Maintenance Margin of security segment's portfolio with no discounts or intraday credits
	case fullMaintMarginReqSecurities = "FullMaintMarginReq-S"

	/// Value of funds value (money market funds + mutual funds)
	case fundValue = "FundValue"

	/// Real-time market-to-market value of futures options
	case futureOptionValue = "FutureOptionValue"

	/// Real-time changes in futures value since last settlement
	case futuresPNL = "FuturesPNL"

	/// Cash balance in related IB-UKL account
	case fxCashBalance = "FxCashBalance"

	/// Gross Position Value in securities segment
	case grossPositionValue = "GrossPositionValue"

	/// Long Stock Value + Short Stock Value + Long Option Value + Short Option Value
	case grossPositionValueSecurities = "GrossPositionValue-S"

	/// Margin rule for IB-IN accounts
	case indianStockHaircut = "IndianStockHaircut"

	/// Initial Margin requirement of whole portfolio
	case initMarginReq = "InitMarginReq"

	/// Initial Margin of the commodity segment in base currency
	case initMarginReqCommodities = "InitMarginReq-C"

	/// Initial Margin of the security segment in base currency
	case initMarginReqSecurities = "InitMarginReq-S"

	/// Real-time mark-to-market value of Issued Option
	case issuerOptionValue = "IssuerOptionValue"

	/// GrossPositionValue / NetLiquidation in security segment
	case leverageSecurities = "Leverage-S"

	/// Time when look-ahead values take effect
	case lookAheadNextChange = "LookAheadNextChange"

	/// This value reflects your available funds at the next margin change
	case lookAheadAvailableFunds = "LookAheadAvailableFunds"

	/// Net Liquidation Value - look ahead Initial Margin
	case lookAheadAvailableFundsCommodities = "LookAheadAvailableFunds-C"

	/// Equity with Loan Value - look ahead Initial Margin
	case lookAheadAvailableFundsSecurities = "LookAheadAvailableFunds-S"

	/// This value reflects your excess liquidity at the next margin change
	case lookAheadExcessLiquidity = "LookAheadExcessLiquidity"

	/// Net Liquidation Value - look ahead Maintenance Margin
	case lookAheadExcessLiquidityCommodities = "LookAheadExcessLiquidity-C"

	/// Equity with Loan Value - look ahead Maintenance Margin
	case lookAheadExcessLiquiditySecurities = "LookAheadExcessLiquidity-S"

	/// Initial margin requirement of whole portfolio as of next period's margin change
	case lookAheadInitMarginReq = "LookAheadInitMarginReq"

	/// Initial margin requirement as of next period's margin change in the base currency of the account
	case lookAheadInitMarginReqCommodities = "LookAheadInitMarginReq-C"

	/// Initial margin requirement as of next period's margin change in the base currency of the account
	case lookAheadInitMarginReqSecurities = "LookAheadInitMarginReq-S"

	/// Maintenance margin requirement of whole portfolio as of next period's margin change
	case lookAheadMaintMarginReq = "LookAheadMaintMarginReq"

	/// Maintenance margin requirement as of next period's margin change in the base currency of the account
	case lookAheadMaintMarginReqCommodities = "LookAheadMaintMarginReq-C"

	/// Maintenance margin requirement as of next period's margin change in the base currency of the account
	case lookAheadMaintMarginReqSecurities = "LookAheadMaintMarginReq-S"

	/// Maintenance Margin requirement of whole portfolio
	case maintMarginReq = "MaintMarginReq"

	/// Maintenance Margin for the commodity segment
	case maintMarginReqCommodities = "MaintMarginReq-C"

	/// Maintenance Margin for the security segment
	case maintMarginReqSecurities = "MaintMarginReq-S"

	/// Market value of money market funds excluding mutual funds
	case moneyMarketFundValue = "MoneyMarketFundValue"

	/// Market value of mutual funds excluding money market funds
	case mutualFundValue = "MutualFundValue"

	/// The sum of the Dividend Payable/Receivable Values for the securities and commodities segments of the account
	case netDividend = "NetDividend"

	/// The basis for determining the price of the assets in your account
	case netLiquidation = "NetLiquidation"

	/// Total cash value + futures PNL + commodities options value
	case netLiquidationCommodities = "NetLiquidation-C"

	/// Total cash value + stock value + securities options value + bond value
	case netLiquidationSecurities = "NetLiquidation-S"

	/// Net liquidation for individual currencies
	case netLiquidationByCurrency = "NetLiquidationByCurrency"

	/// Real-time mark-to-market value of options
	case optionMarketValue = "OptionMarketValue"

	/// Personal Account shares value of whole portfolio
	case paSharesValue = "PASharesValue"

	/// Personal Account shares value in commodity segment
	case paSharesValueCommodities = "PASharesValue-C"

	/// Personal Account shares value in security segment
	case paSharesValueSecurities = "PASharesValue-S"

	/// Total projected "at expiration" excess liquidity
	case postExpirationExcess = "PostExpirationExcess"

	/// Provides a projected "at expiration" excess liquidity based on the soon-to expire contracts in your portfolio in commodity segment
	case postExpirationExcessC = "PostExpirationExcess-C"

	/// Provides a projected "at expiration" excess liquidity based on the soon-to expire contracts in your portfolio in security segment
	case postExpirationExcessSecurities = "PostExpirationExcess-S"

	/// Total projected "at expiration" margin
	case postExpirationMargin = "PostExpirationMargin"

	/// Provides a projected "at expiration" margin value based on the soon-to expire contracts in your portfolio in commodity segment
	case postExpirationMarginCommodities = "PostExpirationMargin-C"

	/// Provides a projected "at expiration" margin value based on the soon-to expire contracts in your portfolio in security segment
	case postExpirationMarginSecurities = "PostExpirationMargin-S"

	/// Marginable Equity with Loan value as of 16:00 ET the previous day in securities segment
	case previousDayEquityWithLoanValue = "PreviousDayEquityWithLoanValue"

	/// Marginable Equity with Loan value as of 16:00 ET the previous day
	case previousDayEquityWithLoanValueSecurities = "PreviousDayEquityWithLoanValue-S"

	/// Open positions are grouped by currency
	case realCurrency = "RealCurrency"

	/// Shows your profit on closed positions, which is the difference between your entry execution cost and exit execution costs
	/// (execution price + commissions to open the positions) - (execution price + commissions to close the position)
	case realizedPnL = "RealizedPnL"

	/// Regulation T equity for universal account
	case regTEquity = "RegTEquity"

	/// Regulation T equity for security segment
	case regTEquitySecurities = "RegTEquity-S"

	/// Regulation T margin for universal account
	case regTMargin = "RegTMargin"

	/// Regulation T margin for security segment
	case regTMarginSecurities = "RegTMargin-S"

	/// Line of credit created when the market value of securities in a Regulation T account increase in value
	case sma = "SMA"

	/// Regulation T Special Memorandum Account balance for security segment
	case smaSecurities = "SMA-S"

	/// Account segment name
	case segmentTitle = "SegmentTitle"

	/// Real-time mark-to-market value of stock
	case stockMarketValue = "StockMarketValue"
	
	/// Value of treasury bonds
	case tBondValue = "TBondValue"

	/// Value of treasury bills
	case tBillValue = "TBillValue"

	/// Total Cash Balance including Future PNL
	case totalCashBalance = "TotalCashBalance"
		
	/// Total cash value of stock, commodities and securities
	case totalCashValue = "TotalCashValue"

	/// CashBalance in commodity segment
	case totalCashValueCommodities = "TotalCashValue-C"

	/// CashBalance in security segment
	case totalCashValueSecurities = "TotalCashValue-S"
	
	/// Account Type
	case tradingTypeSecurities = "TradingType-S"

	/// The difference between the current market value of your open positions and the average cost
	/// Value - Average Cost
	case unrealizedPnL = "UnrealizedPnL"

	/// Value of warrants
	case warrantValue = "WarrantValue"

	/// To check projected margin requirements under Portfolio Margin model
	case whatIfPMEnabled = "WhatIfPMEnabled"
	
	case leverage = "Leverage"
	
	// MARK: - undoccumented keys
	
	case cryptoCurrency = "Cryptocurrency"
	
	case ColumnPrioS = "ColumnPrio-S"
	
	case Guarantee = "Guarantee"
	
	case IncentiveCoupons = "IncentiveCoupons"
	
	case NLVAndMarginInReview = "NLVAndMarginInReview"
	
	case NetLiquidationUncertainty = "NetLiquidationUncertainty"
	
	case PhysicalCertificateValue = "PhysicalCertificateValue"
	
	case SegmentTitleS = "SegmentTitle-S"
	
	case TotalDebitCardPendingCharges = "TotalDebitCardPendingCharges"
	
	case GrossPositionValueP = "GrossPositionValue-P"
	
	case GuaranteeP = "Guarantee-P"
	
	case IncentiveCouponsP = "IncentiveCoupons-P"
	
	case IndianStockHaircutP = "IndianStockHaircut-P"
	
	case InitMarginReqP = "InitMarginReq-P"
	
	case LeverageP = "Leverage-P"
	
	case LookAheadAvailableFundsP = "LookAheadAvailableFunds-P"
	
	case LookAheadExcessLiquidityP = "LookAheadExcessLiquidity-P"
	
	case LookAheadInitMarginReqP = "LookAheadInitMarginReq-P"
	
	case LookAheadMaintMarginReqP = "LookAheadMaintMarginReq-P"
	
	case MaintMarginReqP = "MaintMarginReq-P"
	
	case ColumnPrioP = "ColumnPrio-P"
	
	case BillableP	= "Billable-P"
	
	case AvailableFundsP = "AvailableFunds-P"
	
	case AccruedDividendP = "AccruedDividend-P"
	
	case AccruedCashP = "AccruedCash-P"

	case FullMaintMarginReqP = "FullMaintMarginReq-P"
	
	case FullInitMarginReqP = "FullInitMarginReq-P"
	
	case FullExcessLiquidityP = "FullExcessLiquidity-P"
	
	case FullAvailableFundsP = "FullAvailableFunds-P"
	
	case ExcessLiquidityP = "ExcessLiquidity-P"
	
	case EquityWithLoanValueP = "EquityWithLoanValue-P"
	
	case PostExpirationExcessP = "PostExpirationExcess-P"
	
	case PhysicalCertificateValueP	= "PhysicalCertificateValue-P"
	
	case PASharesValueP	= "PASharesValue-P"
	
	case NetLiquidationP	= "NetLiquidation-P"
	
	case PostExpirationMarginP	= "PostExpirationMargin-P"
	
	case TotalDebitCardPendingChargesP	= "TotalDebitCardPendingCharges-P"
	
	case TotalCashValueP = "TotalCashValue-P"
	
	case SegmentTitleP = "SegmentTitle-P"
	
	case SettledCashByDate = "SettledCashByDate"
	
	case SettledCashByDateP = "SettledCashByDate-P"

	case SettledCashByDateS = "SettledCashByDate-S"

}


extension AccountUpdateKeys: CustomStringConvertible {
	public var description: String {
		return self.rawValue
	}
}


extension AccountUpdateKeys {
	
	public static var all: [Self]{
		return Self.allCases
	}
	
	public func margin(includeSegments: Bool = false) -> [Self] {
		
		let a: [Self] = [
			.initMarginReq,
			.fullInitMarginReq,
			.lookAheadInitMarginReq,
			.maintMarginReq,
			.fullMaintMarginReq
		]
		
		let b: [Self] = [
			.initMarginReqSecurities,
			.initMarginReqCommodities,
			.fullInitMarginReqSecurities,
			.fullInitMarginReqCommodities,
			.maintMarginReqSecurities,
			.maintMarginReqCommodities,
			.fullMaintMarginReqSecurities,
			.fullMaintMarginReqCommodities
		]
		
		return includeSegments == false ? a : a + b
	}
	
	public func balances(includeSegments: Bool = false) -> [Self] {
		
		let a: [Self] = [
			.netLiquidation,
			.accruedCash,
			.accruedDividend,
			.availableFunds,
			.buyingPower,
			.cashBalance,
			.cushion,
			.equityWithLoanValue,
			.excessLiquidity
		]
		
		let b: [Self] = []
		
		return includeSegments == false ? a : a + b
	}
	
	public var valueType: Decodable.Type {
		switch self {
		case .tradingTypeSecurities: return String.self
		case .SegmentTitleS:	return String.self
		case .SegmentTitleP:	return String.self
		case .realCurrency: 	return String.self
		case .currency: 		return String.self
		case .accountCode: 		return String.self
		case .accountOrGroup: 	return String.self
		case .accountType: 		return String.self
		case .accountReady: 	return String.self
		case .NLVAndMarginInReview: return String.self
		case .SettledCashByDate: return String.self
		case .SettledCashByDateP: return String.self
		case .SettledCashByDateS: return String.self
		default: return Double.self
		}
	}
	
	
	
}

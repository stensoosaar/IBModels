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
 Specifies contract detail description
 */
public struct ContractDetails: AnyContract, Hashable, Equatable, Sendable{
		
	///The unique IB contract identifier.
	public var id: Int?
	
	/// securities type
	public var type: SecuritiesType?
	
	///The underlying’s asset symbol.
	public var symbol: String?
	
	///The underlying’s currency.
	public var currency: String?
	
	/**
	 The contract’s last trading day or contract month (for Options and Futures).
	 
	 Strings with format YYYYMM will be interpreted as the Contract Month
	 whereas YYYYMMDD will be interpreted as Last Trading Day.
	 */
	public var expiration: DateComponents?
	
	/**
	 The contract’s last trading day.
	 */
	public var lastTradeDate: Date?
	
	/**
	 The option’s strike price.
	 */
	public var strike: Double?
	
	/**
	 Option's execution right (i.e. call, put)
	 */
	public var right: Contract.ExecutionRight?
	
	/**
	 The instrument’s multiplier (i.e. options, futures).
	 */
	public var multiplier: Double?
	
	/**
	 The destination exchange.
	 */
	public var exchange: String?
	
	/**
	 The contract’s primary exchange.
	 
	 For smart routed contracts, used to define contract in case of ambiguity. Should be defined as native exchange of contract.
	 
	 - Note: For exchanges which contain a period in name, will only be part of exchange name prior to period, i.e. ENEXT for ENEXT.BE
	 */
	public var primaryExchange: String?
	
	/**
	 The contract’s symbol within its primary exchange. For options, this will be the OCC symbol
	 */
	public var localSymbol: String?
	
	/**
	 The trading class name for this contract.
	 
	 Available in TWS contract description window as well. For example, GBL Dec ’13 future’s trading class is “FGBL”
	 */
	public var tradingClass: String?
	
	/**
	 Global unique security’s identifier (i.e. isin, cuspip, figi, etc)
	 when querying contract’s details or placing orders
	 */
	public var globalID: GlobalIdentifier?
	
	/**
	 If set to true, contract details requests and historical data queries can be performed pertaining to expired futures contracts. Expired options or other instrument types are not available.
	 */
	public var includeExpired: Bool?

	
	//MARK: - extended fields
	
	/// The market name for this product.
	public var marketName: String?
	
	/**
	 The minimum allowed price variation.
	 
	 Note that many securities vary their minimum tick size according to their price. This value will only show the smallest of the different minimum tick sizes regardless of the product’s price. Full information about the minimum increment price structure can be obtained with the reqMarketRule function or the IB Contract and Security Search site.
	 */
	public var minTick: Double?
	
	/**
	 Allows execution and strike prices to be reported consistently with market data
	 */
	public var priceMagnifier: Int?
	
	/**
	 Supported order types for this product.
	 */
	public var orderTypes: [OrderType]?
	
	/**
	 Valid exchange fields when placing an order for this contract.
	 */
	public var validExchanges: [String]?
	
	/**
	 Undrlying contract ib id for derivative contracts
	 */
	public var underConid:Int?
	
	///Descriptive name of the product.
	public var longName: String?
	
	/// Typically the contract month of the underlying for a Future contract.
	public var contractMonth: String?
	
	/// The industry classification of the underlying/product.
	public var industry: String?
	
	/// The industry category of the underlying.
	public var category: String?
	
	/// The industry subcategory of the underlying.
	public var subcategory: String?
	
	/// The trading calendar of the product.
	public var tradingCalendar: TradingCalendar?
	
	/**
	 Contains the Economic Value Rule name and the respective optional argument.
	 The two values should be separated by a colon.
	 */
	public var evRule: String?
	
	/**
	 How much the market value of a contract would change if the price were to change by 1.
	 It cannot be used to get market value by multiplying the price by the approximate multiplier.
	 */
	public var evMultiplier: Double?
	
	/**
	 A list of contract identifiers that the customer is allowed to view. CUSIP/ISIN/etc.
	 - note: For US stocks
	 */
	public var secIdList: [GlobalIdentifier]?
	
	/**
	 Aggregated group Indicates the smart-routing group to which a contract belongs.
	 Contracts which cannot be smart-routed have aggGroup = -1.
	 */
	public var aggGroup: Int?
	
	/// Underlying contract symbol for derivate contract
	public var underSymbol: String?
	
	/// Underlying contract type for derivate contract
	public var underSecType: SecuritiesType?
	
	/**
	 The list of market rule IDs separated by comma Market rule IDs can be used to determine the minimum price increment at a given price.
	 */
	public var marketRuleIds: [String: String]?
	
	/**
	 Real expiration date
	 */
	public var realExpirationDate: Date?
	
	/**
	 Last trade time
	 */
	public var lastTradeTime: String?
	
	/**
	 contract subtype for stocks (i.e. common, preferred)
	 */
	public var stockType:  String?
	
	/**
	 Order’s minimal size.
	 */
	public var minSize: Double?
	
	/**
	 Order’s size increment.
	 */
	public var sizeIncrement: Double?
	
	/**
	 Order’s suggested size increment.
	 */
	public var suggestedSizeIncrement: Double?

	
	//MARK: - bond values
	
	/**
	 The nine-character bond CUSIP. For Bonds only. Receiving CUSIPs requires a CUSIP market data subscription.
	 */
	public var cusip: String?
	
	/**
	 Identifies the credit rating of the issuer.
	 
	 A higher credit rating generally indicates a less risky investment. Bond ratings are from Moody’s and S&P respectively. Not currently implemented due to bond market data restrictions.
	 
	 - Note: For Bonds only
	 */
	public var ratings: String?
	
	/**
	 A description string containing further descriptive information about the bond.
	 
	 - Note: For Bonds only
	 */
	public var descAppend: String?
	
	/**
	 The type of bond
	 - Note: For Bonds only
	 */
	public var bondType: String?
	
	/**
	 The type of bond coupon.
	 - Note: For Bonds only
	 - Important: Not implemented
	 */
	public var couponType: String?
	
	/**
	 Callable or redeemable bonds are bonds that can be redeemed or paid off by the issuer prior to the bonds' maturity date.
	 - Note: For Bonds only
	 */
	public var callable: Bool?
	
	/**
	 Bond that provides the holder of a bond (investor) the right, but not the obligation, to force the issuer to redeem the bond before its maturity date
	 - Note: For Bonds only
	 */
	public var putable: Bool?
	
	/**
	 The interest rate used to calculate the amount you will receive in interest payments over the course of the year.
	 - Note: For Bonds only
	 - Important: Not implemented
	 */
	public var coupon: Double?
	
	/**
	 fixed-income corporate debt security that yields interest payments but can be converted into a predetermined number of common stock or equity shares
	 - Note: For Bonds only
	 */
	public var convertible: Bool?
	
	/**
	 The date on which the issuer must repay the face value of the bond. This field is currently not available from the TWS API
	 
	 - Note: For Bonds only
	 - Important: Not implemented
	 */
	public var maturity: String?
	
	/**
	 The date the bond was issued. This field is currently not available from the TWS API.
	 - Note: For Bonds only
	 - Important: Not implemented

	 */
	public var issueDate: String?
	
	/**
	 Only if bond has embedded options. Refers to callable bonds and puttable bonds
	 - Note: For Bonds that have embbeded oprions.
	 - Important: Not implemented
	 */
	public var nextOptionDate: String?
	
	/**
	 Type of embedded option
	 - Note: For Bonds only
	 - Important: Not implemented

	 */
	public var nextOptionType: String?
	
	/**
	 Only if bond has embedded options.
	 - Note: For Bonds that have embbeded oprions
	 - Important: Not implemented

	 */
	public var nextOptionPartial: Bool?
	
	/**
	 If populated for the bond in IB’s database.
	 - Note: For Bonds only
	 */
	public var notes: String?
	
	
	//MARK: - fund values
	
	
	/**
	 Fund's name
	 */
	public var fundName: String?
	
	/**
	 Fund's familty that has same provider / management company
	 */
	public var fundFamily: String?
	
	/**
	 Fund type
	 */
	public var fundType: String?
	
	/**
	 A sales charge or commission that an investor pays "upfront"—that is, upon purchase of the asset.
	 */
	public var fundFrontLoad: String?
	
	/**
	 A fee paid by investors when selling mutual fund shares, and it is expressed as a percentage of the value of the fund's shares.
	 */
	public var fundBackLoad: String?
	
	/**
	 Time period when fund's back load fee is applicable
	 */
	public var fundBackLoadTimeInterval: String?
	
	/**
	 A management fee is a periodic payment that is paid by an investment fund to the fund's investment adviser for investment and portfolio management services.
	 */
	public var fundManagementFee: String?
	
	/**
	 Is the fund closed or open
	 */
	public var fundClosed: Bool?
	
	/**
	 Does the fund accept new investors
	 */
	public var fundClosedForNewInvestors: Bool?
	
	/**
	 Does the fund accept new money
	 */
	public var fundClosedForNewMoney: Bool?
	
	/**
	 
	 */
	public var fundNotifyAmount: String?
	
	/**
	 Fund’s minimum initial purchase.
	 */
	public var fundMinimumInitialPurchase: String?
	
	/**
	 Fund’s subsequent minimum purchase.
	 */
	public var fundSubsequentMinimumPurchase: String?
	
	/**
	 "Blue sky states" are U.S. states that require investment funds to comply with state-level securities laws—known as Blue Sky Laws—through registration or notice filings to protect investors from fraud.
	 */
	public var fundBlueSkyStates: String?
	
	/**
	 "Blue sky territories" are U.S. territories that require investment funds to comply with state-level securities laws—known as Blue Sky Laws—through registration or notice filings to protect investors from fraud.
	 */
	public var fundBlueSkyTerritories: String?
	
	public enum FundDistributionPolicy: String, Codable, Sendable{
		case none = "None"
		case accumulation = "N"
		case income = "Y"
	}
	
	
	/**
	 Does the fund pays dividends or reinvests its profits
	 */
	public var fundDistributionPolicy: FundDistributionPolicy?
	
	public enum FundAssetType: String, Codable, Sendable {
		case none = "None"
		case others = "000"
		case moneyMarket = "001"
		case fixedIncome = "002"
		case multiAsset = "003"
		case equity = "004"
		case sector = "005"
		case guaranteed = "006"
		case alternative = "007"
	}
	
	
	/**
	 Asset classes, fund invests into
	 */
	public var fundAssetType: FundAssetType?
	
	public struct IneligibilityReason: Codable, Sendable{
		
		var id: String
		var description: String
		
		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.id = try container.decode(String.self)
			self.description = try container.decode(String.self)
		}
		
	}
	
	public var ineligibilityReasons: [IneligibilityReason]?
	
}




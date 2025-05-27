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



public enum TickType: Int, Sendable, CaseIterable, Decodable {
	case bidSize = 0
	case bid = 1
	case ask = 2
	case askSize = 3
	case last = 4
	case lastSize = 5
	case highPrice = 6
	case lowPrice = 7
	case volume = 8
	case closePrice = 9
	case bidOption = 10
	case askOption = 11
	case lastOption = 12
	case modelOption = 13
	case openPrice = 14
	case low13Week = 15
	case high13Week = 16
	case low26Week = 17
	case high26Week = 18
	case low52Week = 19
	case high52Week = 20
	case avgVolume = 21
	case openInterest = 22
	case optionHistoricalVol = 23
	case optionImpliedVol = 24
	case optionBidExch = 25
	case optionAskExch = 26
	case optionCallOpenInterest = 27
	case optionPutOpenInterest = 28
	case optionCallVolume = 29
	case optionPutVolume = 30
	case indexFuturePremium = 31
	case bidExch = 32
	case askExch = 33
	case auctionVolume = 34
	case auctionPrice = 35
	case auctionImbalance = 36
	case markPrice = 37
	case bidEFPComputation = 38
	case askEFPComputation = 39
	case lastEFPComputation = 40
	case openEFPComputation = 41
	case highEFPComputation = 42
	case lowEFPComputation = 43
	case closeEFPComputation = 44
	case lastTimestamp = 45
	case shortable = 46
	case fundamentalRatios = 47
	case rtVolume = 48
	case halted = 49
	case bidYield = 50
	case askYield = 51
	case lastYield = 52
	case custOptionComputation = 53
	case tradeCount = 54
	case tradeRate = 55
	case volumeRate = 56
	case lastRTHTrade = 57
	case rtHistoricalVol = 58
	case ibDividends = 59
	case bondFactorMultiplier = 60
	case regulatoryImbalance = 61
	case news = 62
	case shortTermVolume3Min = 63
	case shortTermVolume5Min = 64
	case shortTermVolume10Min = 65
	case delayedBid = 66
	case delayedAsk = 67
	case delayedLast = 68
	case delayedBidSize = 69
	case delayedAskSize = 70
	case delayedLastSize = 71
	case delayedHigh = 72
	case delayedLow = 73
	case delayedVolume = 74
	case delayedClose = 75
	case delayedOpen = 76
	case rtTradeVolume = 77
	case creditmanMarkPrice = 78
	case creditmanSlowMarkPrice = 79
	case delayedBidOption = 80
	case delayedAskOption = 81
	case delayedLastOption = 82
	case delayedModelOption = 83
	case lastExch = 84
	case lastRegTime = 85
	case futuresOpenInterest = 86
	case avgOptVolume = 87
	case delayedLastTimestamp = 88
	case shortableShares = 89
	case delayedHalted = 90
	case reuters2MutualFunds = 91
	case etfNavClose = 92
	case etfNavPriorClose = 93
	case etfNavBid = 94
	case etfNavAsk = 95
	case etfNavLast = 96
	case etfFrozenNavLast = 97
	case etfNavHigh = 98
	case etfNavLow = 99
	case socialMarketAnalytics = 100
	case estimatedIPOMidpoint = 101
	case finalIPOLast = 102
	case delayedYieldBid = 103
	case delayedYieldAsk = 104
}


extension TickType: CustomStringConvertible {

	public var description: String {
		switch self {
		case .bidSize: return "bid size"
		case .bid: return "bid"
		case .ask: return "ask"
		case .askSize: return "ask size"
		case .last: return "last"
		case .lastSize: return "last size"
		case .highPrice: return "high"
		case .lowPrice: return "low"
		case .volume: return "volume"
		case .closePrice: return "close"
		case .bidOption: return "bidOptComp"
		case .askOption: return "askOptComp"
		case .lastOption: return "lastOptComp"
		case .modelOption: return "modelOptComp"
		case .openPrice: return "open"
		case .low13Week: return "13 week low"
		case .high13Week: return "13 week high"
		case .low26Week: return "26 week low"
		case .high26Week: return "26 week high"
		case .low52Week: return "52 week low"
		case .high52Week: return "52 week high"
		case .avgVolume: return "Avg Volume"
		case .openInterest: return "Open Interest"
		case .optionHistoricalVol: return "Option Historical Volatility"
		case .optionImpliedVol: return "Option Implied Volatility"
		case .optionBidExch: return "OptionBidExchange"
		case .optionAskExch: return "OptionAskExchange"
		case .optionCallOpenInterest: return "OptionCallOpenInterest"
		case .optionPutOpenInterest: return "OptionPutOpenInterest"
		case .optionCallVolume: return "OptionCallVolume"
		case .optionPutVolume: return "OptionPutVolume"
		case .indexFuturePremium: return "IndexFuturePremium"
		case .bidExch: return "bidExch"
		case .askExch: return "askExch"
		case .auctionVolume: return "auctionVolume"
		case .auctionPrice: return "auctionPrice"
		case .auctionImbalance: return "auctionImbalance"
		case .markPrice: return "markPrice"
		case .bidEFPComputation: return "bidEFP"
		case .askEFPComputation: return "askEFP"
		case .lastEFPComputation: return "lastEFP"
		case .openEFPComputation: return "openEFP"
		case .highEFPComputation: return "highEFP"
		case .lowEFPComputation: return "lowEFP"
		case .closeEFPComputation: return "closeEFP"
		case .lastTimestamp: return "lastTimestamp"
		case .shortable: return "shortable"
		case .fundamentalRatios: return "fundamentals"
		case .rtVolume: return "RTVolume"
		case .halted: return "halted"
		case .bidYield: return "bidYield"
		case .askYield: return "askYield"
		case .lastYield: return "lastYield"
		case .custOptionComputation: return "custOptComp"
		case .tradeCount: return "tradeCount"
		case .tradeRate: return "tradeRate"
		case .volumeRate: return "volumeRate"
		case .lastRTHTrade: return "lastRTHTrade"
		case .rtHistoricalVol: return "RTHistoricalVol"
		case .ibDividends: return "IBDividends"
		case .bondFactorMultiplier: return "bondFactorMultiplier"
		case .regulatoryImbalance: return "regulatoryImbalance"
		case .news: return "news"
		case .shortTermVolume3Min: return "shortTermVolume3Min"
		case .shortTermVolume5Min: return "shortTermVolume5Min"
		case .shortTermVolume10Min: return "shortTermVolume10Min"
		case .delayedBid: return "delayedBid"
		case .delayedAsk: return "delayedAsk"
		case .delayedLast: return "delayedLast"
		case .delayedBidSize: return "delayedBidSize"
		case .delayedAskSize: return "delayedAskSize"
		case .delayedLastSize: return "delayedLastSize"
		case .delayedHigh: return "delayedHigh"
		case .delayedLow: return "delayedLow"
		case .delayedVolume: return "delayedVolume"
		case .delayedClose: return "delayedClose"
		case .delayedOpen: return "delayedOpen"
		case .rtTradeVolume: return "RT TradeVolume"
		case .creditmanMarkPrice: return "creditmanMarkPrice"
		case .creditmanSlowMarkPrice: return "creditmanSlowMarkPrice"
		case .delayedBidOption: return "delayedBidOptComp"
		case .delayedAskOption: return "delayedAskOptComp"
		case .delayedLastOption: return "delayedLastOptComp"
		case .delayedModelOption: return "delayedModelOptComp"
		case .lastExch: return "lastExchange"
		case .lastRegTime: return "lastRegTime"
		case .futuresOpenInterest: return "futuresOpenInterest"
		case .avgOptVolume: return "avgOptVolume"
		case .delayedLastTimestamp: return "delayedLastTimestamp"
		case .shortableShares: return "shortableShares"
		case .delayedHalted: return "delayedHalted"
		case .reuters2MutualFunds: return "reuters2MutualFunds"
		case .etfNavClose: return "etfNavClose"
		case .etfNavPriorClose: return "etfNavPriorClose"
		case .etfNavBid: return "etfNavBid"
		case .etfNavAsk: return "etfNavAsk"
		case .etfNavLast: return "etfNavLast"
		case .etfFrozenNavLast: return "etfFrozenNavLast"
		case .etfNavHigh: return "etfNavHigh"
		case .etfNavLow: return "etfNavLow"
		case .socialMarketAnalytics: return "socialMarketAnalytics"
		case .estimatedIPOMidpoint: return "estimatedIPOMidpoint"
		case .finalIPOLast: return "finalIPOLast"
		case .delayedYieldBid: return "delayedYieldBid"
		case .delayedYieldAsk: return "delayedYieldAsk"
		}
	}
	
}

/*
extension TickType {
	
	var side: TickSide? {
		switch self {

		case .bidPrice: return .bid
		case .bidSize: return .bid
		case .delayedBid: return .bid
		case .delayedBidSize: return .bid
		case .bidExch: return .bid
		case .bidYield: return .bid
		case .bidOption: return .bid
		case .bidEFPComputation: return .bid
		case .etfNavBid: return .bid
		case .optionBidExch: return .bid
		case .delayedBidOption: return .bid

		case .askPrice: return .ask
		case .askSize: return .ask
		case .delayedAsk: return .ask
		case .delayedAskSize: return .ask
		case .askExch: return .ask
		case .askYield: return .ask
		case .askOption: return .ask
		case .askEFPComputation: return .ask
		case .etfNavAsk: return .ask
		case .optionAskExch: return .ask
		case .delayedAskOption: return .ask

		case .lastPrice: return .trade
		case .lastSize: return .trade
		case .delayedLast: return .trade
		case .delayedLastSize: return .trade
		case .lastExch: return .trade
		case .lastYield: return .trade
		case .lastOption: return .trade
		case .lastEFPComputation: return .trade
		case .etfNavLast: return .trade
		case .delayedLastOption: return .trade

		default: return nil

		}
	}
	
}
*/

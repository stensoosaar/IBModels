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



struct TickDecoder: IBDecodable{
	
	let id: Int
	let result: IBEvent
	
	init(from decoder: IBDecoder) throws {
				
		guard let str = try? decoder.peek(offset: 2),
			  let int = Int(str),
			  let tickType = TickType(rawValue: int)
		else {
			throw IBError.decodingError("failed to decode tick type \(decoder.description)")
		}
		

		switch tickType {
			
		case .bid, .ask, .last, .delayedAsk, .delayedBid, .delayedLast:
			let object = try TickQuote(from: decoder)
			id = object.id
			result = object

		case .bidSize, .askSize, .lastSize, .delayedAskSize, .delayedBidSize, .delayedLastSize:
			let object  = try TickSize(from: decoder)
			id = object.id
			result = object

		case .openPrice, .highPrice, .lowPrice, .closePrice, .delayedOpen, .delayedHigh, .delayedLow, .delayedClose:
			let object  = try TickPrice(from: decoder)
			id = object.id
			result = object

		case .volume, .delayedVolume, .avgVolume:
			let object  = try TickSize(from: decoder)
			id = object.id
			result = object

		case .low13Week, .high13Week, .low26Week, .high26Week, .low52Week, .high52Week:
			let object  = try TickPrice(from: decoder)
			id = object.id
			result = object

		case .halted, .delayedHalted:
			let object  = try TradingStatus(from: decoder)
			id = object.id
			result = object

		case .ibDividends:
			let object  = try TickDividends(from: decoder)
			id = object.id
			result = object

		case .lastTimestamp, .delayedLastTimestamp, .lastRegTime:
			 let object  = try TickTimestamp(from: decoder)
			id = object.id
			result = object

		case .bidYield, .askYield, .lastYield, .delayedYieldAsk, .delayedYieldBid:
			 let object  = try TickPrice(from: decoder)
			id = object.id
			result = object

		case .askExch, .bidExch, .lastExch, .optionAskExch, .optionBidExch:
			let object  = try TickExchange(from: decoder)
			id = object.id
			result = object

		case .news:
			let object  = try TickNews(from: decoder)
			id = object.id
			result = object

		case .rtVolume, .rtTradeVolume:
			let object  = try RTVolumeSales(from: decoder)
			id = object.id
			result = object

		case .bidEFPComputation, .askEFPComputation, .lastEFPComputation:
			let object  = try TickEFP(from: decoder)
			id = object.id
			result = object

		case .openEFPComputation,  .highEFPComputation, .lowEFPComputation, .closeEFPComputation:
			let object  = try TickEFP(from: decoder)
			id = object.id
			result = object

		case .bidOption, .askOption, .lastOption:
			let object  = try TickOptionComputation(from: decoder)
			id = object.id
			result = object

		case .modelOption,  .delayedModelOption:
			let object  = try TickOptionComputation(from: decoder)
			id = object.id
			result = object

		case .custOptionComputation:
			let object  = try TickOptionComputation(from: decoder)
			id = object.id
			result = object

		case .openInterest, .optionPutOpenInterest, .optionCallOpenInterest, .futuresOpenInterest:
			let object  = try TickSize(from: decoder)
			id = object.id
			result = object

		case .shortTermVolume3Min, .shortTermVolume5Min, .shortTermVolume10Min:
			let object  = try TickSize(from: decoder)
			id = object.id
			result = object

		default:
			throw IBError.decodingError("unable to decode tick type \(tickType) \(decoder.description)")
		}
		
	}
}

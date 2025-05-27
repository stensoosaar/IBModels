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
 Specifies order's execution conditions
 */
public enum OrderType: String, Codable, Sendable {
	
	/**
	 An auction order is entered into the electronic trading system during the pre-market opening period for execution at the Calculated Opening Price (COP).
	 
	 If your order is not filled on the open, the order is re-submitted as a limit order with the limit price set to the COP or the best bid/ask after the market opens.
	
	 Products: STK, FUND, FUT
	 
	 Regions: Non-US Products Only
	 
	 Routing: Directed
	 */
	case auction = "AUC"
	
	/**
	 A Market order is an order to buy or sell at the market bid or offer price.
	 
	 A market order may increase the likelihood of a fill and the speed of execution, but unlike the Limit order a Market order provides no price protection and
	 may fill at a price far lower/higher than the current displayed bid/ask.
	 
	 ```Swift
	 let order = Order()
	 order.action = .BUY
	 order.type = .MKT
	 order.totalQuantity = 100
	 ```
	 
	 Products: BOND, CFD, EFP, CASH, FUND, FUT, FOP, OPT, STK, WAR
	 
	 Regions: All
	 
	 Routing: Smart, Directed
	*/
	case market = "MKT"
	
	/**
	 A Limit order is an order to buy or sell at a specified price or better.
	 
	 The Limit order ensures that if the order fills, it will not fill at a price less favorable than your limit price, but it does not guarantee a fill.
	 
	 ```Swift
	 let order = Order()
	 order.action = .BUY
	 order.type = .LIMIT
	 order.lmtPrice = 200.00
	 order.totalQuantity = 100
	 ```
	 
	 Products: STK, FUND, OPT, FUT, FOP, CASH, BOND, W, EFPs, Crypto

	 Regions: US and Non-US Products

	 Routing: Smart, Directed
	 
	 */
	case limit = "LMT"
	
	/**
	 A Stop order is an instruction to submit a buy or sell market order if and when the user-specified stop trigger price is attained or penetrated.
	 
	 A Stop order is not guaranteed a specific execution price and may execute significantly away from its stop price. A Sell Stop order is always placed below the current market price and is typically used to limit a loss or protect a profit on a long stock position. A Buy Stop order is always placed above the current market price. It is typically used to limit a loss or help protect a profit on a short sale.
	 
	 ```Swift
	 let order = Order()
	 order.action = .BUY
	 order.type = .STP
	 order.auxPrice = 200.00
	 order.totalQuantity = 100
	 ```
	 
	 Products: Stocks, ETFs, Options, Futures, FOPs, Currencies, Warrants, EFPs, Combos
	 
	 Regions: US and Non-US Products
	 
	 Routing: Smart, Directed, Lite
	 */
	case stop = "STP"
	
	/**
	 A Stop-Limit order is an instruction to submit a buy or sell limit order when the user-specified stop trigger price is attained or penetrated.
	 
	 The order has two basic components: the stop price and the limit price. When a trade has occurred at or through the stop price, the order becomes executable and enters the market as a limit order, which is an order to buy or sell at a specified price or better.
	 
	 ```Swift
	 let order = Order()
	 order.action = .BUY
	 order.type = .STOP_LIMIT
	 order.lmtPrice = 200.30
	 order.auxPrice = 200.00
	 order.totalQuantity = 100
	 ```
	 
	 Products: Stocks, ETFs, Options, Futures, FOPs, Currencies, , Warrants, EFPs
	
	 Regions: US and Non-US Products
	 
	 Routing: Smart, Directed, Lite
	 
	 - Important: A Stop-Limit eliminates the price risk associated with a stop order where the execution price cannot be guaranteed, but exposes the investor to the risk that the order may never fill even if the stop price is reached. The investor could "miss the market" altogether.
	*/
	case stopLimit = "STP LMT"
	
	/**
	 
	 
	 */
	case relative = "REL"
	
	case BOX_TOP = "BOX TOP"
	
	case FIX_PEGGED = "FIX PEGGED"
	/**
	 A Limit if Touched is an order to buy (or sell) a contract at a specified price or better, below (or above) the market.
	 
	 This order is held in the system until the trigger price is touched. An LIT order is similar to a stop limit order, except that an LIT sell order is placed above the current market price, and a stop limit sell order is placed below.

	 Products: BOND, CFD, CASH, FUT, FOP, OPT, STK, WAR
	 */
	case limitIfTouch = "LIT"
	
	case limitPlusMarket = "LMT + MKT"
	
	/**
	 A Limit-on-Open (LOO) order combines a limit order with the OPG time in force to create an order that is submitted at the market's open, and that will only execute at the specified limit price or better. Orders are filled in accordance with specific exchange rules.

	 Products: CFD, STK, OPT, WAR
	 */
	case limitOnClose = "LOC"
	
	/**
	 A Market If Touched (MIT) is an order to buy (or sell) a contract below (or above) the market.
	 
	 Its purpose is to take advantage of sudden or unexpected changes in share or other prices and provides investors with a trigger price to set an order in motion. Investors may be waiting for excessive strength (or weakness) to cease, which might be represented by a specific price point. MIT orders can be used to determine whether or not to enter the market once a specific price level has been achieved. This order is held in the system until the trigger price is touched, and is then submitted as a market order. An MIT order is similar to a stop order, except that an MIT sell order is placed above the current market price, and a stop sell order is placed below
	 
	 Products: BOND, CFD, CASH, FUT, FOP, OPT, STK, WAR
	 
	 Regions: US and Non-US Products
	 
	 Routing: Smart, Directed
	 */
	case marketIfTouched = "MIT"


	case MKT_PRT = "MKT PRT"
	
	/**
	 A Market On Close (MOC) order is a market order that is submitted to execute as close to the closing price as possible.
	 
	 Products: CFD, FUT, STK, WAR
	 */
	case marketOnClose = "MOC"
	
	/**
	 
	 
	 */
	case MARKET_TO_LIMIT = "MTL"
	case PASSV_REL = "PASSV REL"
	case PEG_BENCH = "PEG BENCH"
	case PEG_MID = "PEG MID"
	case PEG_MKT = "PEG MKT"
	case PEG_PRIM = "PEG PRIM"
	case PEG_BEST = "PEG BEST"
	case PEG_STK = "PEG STK"
	case REL_PLUS_LMT = "REL + LMT"
	case REL_PLUS_MKT = "REL + MKT"
	case SNAP_MID = "SNAP MID"
	case SNAP_MKT = "SNAP MKT"
	case SNAP_PRIM = "SNAP PRIM"
	case STP_PRT = "STP PRT"
	
	/**
	 A sell trailing stop order sets the stop price at a fixed amount below the market price with an attached "trailing" amount. As the market price rises, the stop price rises by the trail amount, but if the stock price falls, the stop loss price doesn't change, and a market order is submitted when the stop price is hit. This technique is designed to allow an investor to specify a limit on the maximum possible loss, without setting a limit on the maximum possible gain. "Buy" trailing stop orders are the mirror image of sell trailing stop orders, and are most appropriate for use in falling markets.

	 ```Swift
	 let order = Order()
	 order.action = .BUY
	 order.type = .TRAIL
	 order.totalQuantity = 100
	 order.trailingPercent = 0.25
	 order.trailingStopPrice = 200.00
	 ```
	 
	 - Note: Trailing Stop orders can have the trailing amount specified as a percent, as in the example below, or as an absolute amount which is specified in the auxPrice field.

	 Products: CFD, CASH, FOP, FUT, OPT, STK, WAR
	 */
	case trailing = "TRAIL"
	
	/**
	 A trailing stop limit order is designed to allow an investor to specify a limit on the maximum possible loss, without setting a limit on the maximum possible gain.
	 
	 A SELL trailing stop limit moves with the market price, and continually recalculates the stop trigger price at a fixed amount below the market price, based on the user-defined "trailing" amount. The limit order price is also continually recalculated based on the limit offset. As the market price rises, both the stop price and the limit price rise by the trail amount and limit offset respectively, but if the stock price falls, the stop price remains unchanged, and when the stop price is hit a limit order is submitted at the last calculated limit price.
	 
	 A BUY trailing stop limit order is the mirror image of a sell trailing stop limit, and is generally used in falling markets.

	 ```Swift
	 let order = Order()
	 order.action = .BUY
	 order.type = .TRAIL
	 order.totalQuantity = 100
	 order.trailingPercent = 0.25
	 order.trailingStopPrice = 200.00
	 ```

	 Trailing Stop Limit orders can be sent with the trailing amount specified as an absolute amount, as in the example below, or as a percentage, specified in the trailingPercent field.

	 Products: BOND, CFD, CASH, FUT, FOP, OPT, STK, WAR

	 - important:
	 the 'limit offset' field is set by default in the TWS/IBG settings in v963+. This setting either needs to be changed in the Order Presets, the default value accepted, or the limit price offset sent from the API as in the example below. Not both the 'limit price' and 'limit price offset' fields can be set in TRAIL LIMIT orders.

	 
	 */
	
	case TRAIL_LIMIT = "TRAIL LIMIT"
	case TRAIL_LIT = "TRAIL LIT"
	case TRAIL_LMT_PLUS_MKT = "TRAIL LMT + MKT"
	case TRAIL_MIT = "TRAIL MIT"
	case TRAIL_REL_PLUS_MKT = "TRAIL REL + MKT"
	case VOL = "VOL"
	case VWAP = "VWAP"
	case QUOTE = "QUOTE"
	case PEG_PRIM_VOL = "PPV"
	case PEG_MID_VOL = "PDV"
	case PEG_MKT_VOL = "PMV"
	case PEG_SRF_VOL = "PSV"
}

extension OrderType {
	
	var isVolOrder: Bool{
		return self == .VOL
	}
	
	var isPegBenchOrder: Bool{
		return self == .PEG_BENCH
	}
	
	var isPegMidOrder: Bool{
		return self == .PEG_MID
	}
	
	var isPegBestOrder: Bool{
		return self == .PEG_BEST
	}

}

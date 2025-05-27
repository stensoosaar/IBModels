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
 Observation length for time bars
 */
public enum BarSize: String, Sendable, Codable {
	
	case sec1 = "1 secs"
	
	case secs5 = "5 secs"
	
	case secs10 = "10 secs"
	
	case secs15 = "15 secs"
	
	case secs30 = "30 secs"
	
	case min1 = "1 min"
	
	case mins2 = "2 mins"
	
	case mins3 = "3 mins"
	
	case mins5 = "5 mins"
	
	case mins10 = "10 mins"
	
	case mins15 = "15 mins"
	
	case mins20 = "20 mins"
	
	case mins30 = "30 mins"
	
	case hour1 = "1 hour"
	
	case hours2 = "2 hours"
	
	case hours4 = "4 hours"
	
	case hours8 = "8 hours"
	
	case day = "1 day"
	
	case week = "1 week"
	
	case month = "1 month"
	
}

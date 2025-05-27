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




public struct ExerciseOptionsRequest: IdentifiableRequest{
	
	public enum Action: Int, Codable, Sendable {
		case excerice = 1
		case lapse = 2
	}
	
	public let type: RequestType = .exerciseOptions
	
	private let version:Int = 2

	private let minimumServerVersion: Int = 21
	
	public let id: Int

	public let contract: Contract

	public let action: Action

	public let quantity: Int

	public let account: String

	public let override: Int

	public let manualOrderTime: String

	public let customerAccount:  String

	public let professionalCustomer: Bool
	
	
	/**
	 Creates new request to execrice option
	 
	 - parameter id: request id
	 - parameter contract: contract
	 - parameter action: Action (excerice, lapse)
	 - parameter quantity: the quantity to be excercised
	 - parameter account: destination account name
	 - parameter override:  Specifies whether your setting will override the system's natural action.
	 - parameter manualOrderTime: manual order time
	 - parameter customerAccount: customer account
	 - parameter professionalCustomer: is the customer professional or not
	 
	 - Note:
	 if your action is "exercise" and the option is not in-the-money, by natural action the option would not exercise.
	 If you have override set to "true" the natural action would be overridden and the out-of-the money option would be exercised.
	 */
	public init(
		id: Int,
		contract: Contract,
		action: Action,
		quantity: Int,
		account: String,
		override: Int,
		manualOrderTime: String,
		customerAccount: String ,
		professionalCustomer: Bool
	){
		self.id = id
		self.contract = contract
		self.action = action
		self.quantity = quantity
		self.account = account
		self.override = override
		self.manualOrderTime = manualOrderTime
		self.customerAccount = customerAccount
		self.professionalCustomer = professionalCustomer
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()
			
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
			
		try container.encode(contract)
		
		try container.encode(action)
		try container.encode(quantity)
		try container.encode(account)
		try container.encode(override)
		
		if encoder.serverVersion >= .manualOrderTimeExerciseOptions {
			try container.encode(manualOrderTime)
		}
		
		if encoder.serverVersion >= .customerAccount {
			try container.encode(customerAccount)
		}
		
		if encoder.serverVersion >= .professionalCustomer {
			try container.encode(professionalCustomer)
		}
	}
}

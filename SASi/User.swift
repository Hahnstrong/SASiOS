//
//  User.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Dictionary Keys
    
    private let nameKey = "name"
    private let addressKey = "address"
    private let phoneNumberKey = "phoneNumber"
    private let emailKey = "email"
    private let gateCodeKey = "gateCode"
    private let vehiclesKey = "vehicles"
    
    // MARK: - Properties
    
    var userID: String
    var name: String?
    var address: String?
    var phoneNumer: String?
    var email: String
    var gateCode: String?
    var vehicle: Vehicle?
    
    init(userID: String, name: String? = nil, address: String? = nil, phoneNumer: String? = nil, email: String, gateCode: String? = nil, vehicle: Vehicle? = nil) {
        self.userID = userID
        self.name = name
        self.address = address
        self.phoneNumer = phoneNumer
        self.email = email
        self.gateCode = gateCode
        self.vehicle = vehicle
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[nameKey] as? String,
            let address = dictionary[addressKey] as? String,
            let phoneNumber = dictionary[phoneNumberKey] as? String,
            let emailKey = dictionary[
    }
    
}

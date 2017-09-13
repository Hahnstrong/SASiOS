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
    
    // MARK: - Properties
    
    var name: String?
    var address: String?
    var phoneNumber: String?
    var email: String?
    var gateCode: String?
    
    init(name: String? = nil, address: String? = nil, phoneNumber: String? = nil, email: String?, gateCode: String? = nil) {
        
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.email = email
        self.gateCode = gateCode
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[nameKey] as? String,
            let address = dictionary[addressKey] as? String,
            let phoneNumber = dictionary[phoneNumberKey] as? String,
            let email = dictionary[emailKey] as? String,
            let gateCode = dictionary[gateCodeKey] as? String else { return nil }
        
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.email = email
        self.gateCode = gateCode
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [nameKey: name as Any, addressKey: address as Any, phoneNumberKey: phoneNumber as Any, emailKey: email as Any, gateCodeKey: gateCode as Any]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}

























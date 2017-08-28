//
//  User.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class User {
    
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
}

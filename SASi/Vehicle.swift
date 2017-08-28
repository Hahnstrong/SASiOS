//
//  Vehicle.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class Vehicle {
    
    let year: String
    let make: String
    let model: String
    let prefFuelType: String
    let prefOilType: String
    
    init(year: String, make: String, model: String, prefFuelType: String, prefOilType: String) {
        self.year = year
        self.make = make
        self.model = model
        self.prefFuelType = prefFuelType
        self.prefOilType = prefOilType
    }
}

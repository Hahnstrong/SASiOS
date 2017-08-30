//
//  Vehicle.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class Vehicle {
    
    // MARK: - Dictioanry Keys
    
    private let yearKey = "year"
    private let makeKey = "make"
    private let modelKey = "model"
    private let prefFuelTypeKey = "prefFuelType"
    private let prefOilTypeKey = "prefOilType"
    private let vehicleUUIDKey = "vehicleUUID"
    
    // MARK: - Properties
    
    let year: String
    let make: String
    let model: String
    let prefFuelType: String
    let prefOilType: String
    let vehicleUUID: String
    
    init(year: String, make: String, model: String, prefFuelType: String, prefOilType: String, vehicleUUID: String) {
        self.year = year
        self.make = make
        self.model = model
        self.prefFuelType = prefFuelType
        self.prefOilType = prefOilType
        self.vehicleUUID = vehicleUUID
    }
    
    init?(dictionary: [String: Any]) {
        guard let year = dictionary[yearKey] as? String,
            let make = dictionary[makeKey] as? String,
            let model = dictionary[modelKey] as? String,
            let prefFuelType = dictionary[prefFuelTypeKey] as? String,
            let prefOilType = dictionary[prefOilTypeKey] as? String,
            let vehicleUUID = dictionary[vehicleUUIDKey] as? String else { return nil }
        
        self.year = year
        self.make = make
        self.model = model
        self.prefFuelType = prefFuelType
        self.prefOilType = prefOilType
        self.vehicleUUID = vehicleUUID
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [yearKey: year, makeKey: make, modelKey: model, prefFuelTypeKey: prefFuelType, prefOilTypeKey: prefOilType, vehicleUUIDKey: vehicleUUID]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}

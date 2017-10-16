//
//  Order.swift
//  SASi
//
//  Created by Caleb Strong on 10/6/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class Order {
    
    // MARK: - Dictionary Keys
    
    private let dateKey = "date"
    private let priceKey = "price"
    private let servicesKey = "services"
    private let userIDKey = "userID"
    private let vehicleKey = "vehicle"
    private let isCompletedKey = "isCompleted"
    private let orderUUIDKey = "orderUUID"
    
    // MARK: - Properties
    
    var date: String
    var price: Int
    var services: String
    var userID: String
    var vehicle: String
    var isCompleted: Bool
    var orderUUID: String
    
    init(date: String, price: Int, services: String, userID: String, vehicle: String, isCompleted: Bool, orderUUID: String) {
        self.date = date
        self.price = price
        self.services = services
        self.userID = userID
        self.vehicle = vehicle
        self.isCompleted = isCompleted
        self.orderUUID = orderUUID
    }
    
    init?(dictionary: [String: Any]) {
        guard let date = dictionary[dateKey] as? String,
            let price = dictionary[priceKey] as? Int,
            let services = dictionary[servicesKey] as? String,
            let userID = dictionary[userIDKey] as? String,
            let vehicle = dictionary[vehicleKey] as? String,
            let isCompleted = dictionary[isCompletedKey] as? Bool,
            let orderUUID = dictionary[orderUUIDKey] as? String else { return nil }
        
        self.date = date
        self.price = price
        self.services = services
        self.userID = userID
        self.vehicle = vehicle
        self.isCompleted = isCompleted
        self.orderUUID = orderUUID
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [dateKey: date, priceKey: price, servicesKey: services, userIDKey: userID, vehicleKey: vehicle, isCompletedKey: isCompleted, orderUUIDKey: orderUUID]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}

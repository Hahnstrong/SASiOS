//
//  Service.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class Service {
    
    // MARK: - JSON Keys
    
    private let serviceNameKey = "serviceName"
    private let servicePriceKey = "servicePrice"
    
    // MARK: - Properties
    
    let serviceName: String
    let servicePrice: Int
    var serviceIsChosen: Bool
    
    init(serviceName: String, servicePrice: Int, serviceIsChosen: Bool = false) {
        self.serviceName = serviceName
        self.servicePrice = servicePrice
        self.serviceIsChosen = serviceIsChosen
    }
    
    init?(dictionary: [String: Any]) {
        guard let serviceName = dictionary[serviceNameKey] as? String,
            let servicePrice = dictionary[servicePriceKey] as? Int else { return nil }
        let serviceIsChosen = false
        
        self.serviceName = serviceName
        self.servicePrice = servicePrice
        self.serviceIsChosen = serviceIsChosen
    }
}

//
//  Service.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class Service {
    
    let serviceName: String
    let serviceTime: Int
    var serviceIsChosen: Bool
    
    init(serviceName: String, serviceTime: Int, serviceIsChosen: Bool = false) {
        self.serviceName = serviceName
        self.serviceTime = serviceTime
        self.serviceIsChosen = serviceIsChosen
    }
    
}

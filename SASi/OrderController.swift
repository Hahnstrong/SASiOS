//
//  OrderController.swift
//  SASi
//
//  Created by Caleb Strong on 10/6/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation
import Firebase

class OrderController {
 
    static let shared = OrderController()
    var order: Order?
    let baseURL = URL(string: "https://sasi-ios.firebaseio.com/")
    let userID = Auth.auth().currentUser?.uid
    
    // MARK: - CRUD Functions
    
    func createOrder(date: String, price: Int, services: String, vehicle: String, isCompleted: Bool, orderUUID: String) {
        let order = Order(date: date, price: price, services: services, userID: userID!, vehicle: vehicle, isCompleted: isCompleted, orderUUID: orderUUID)
        putOrderToFirebase(order: order) { (success) in
        }
    }
    
    // MARK: - Firebase API Calls
    
    // PUT
    
    func putOrderToFirebase(order: Order, completion: @escaping(Bool) -> Void) {
        
        guard let baseURL = baseURL,
            let userID = userID else { completion(false); return }
        
        let url = baseURL.appendingPathComponent("users").appendingPathComponent(userID).appendingPathComponent("orders").appendingPathComponent(order.orderUUID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = order.jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8)
                else { completion(false); return }
            
            if let error = error {
                print(error)
                completion(false)
                return
            } else if responseDataString.contains("error") {
                print(responseDataString)
                completion(false)
                return
            } else {
                self.order = order
                completion(true)
                return
            }
        }
        
        dataTask.resume()
        
    }
    
}

//
//  ServiceController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation

class ServiceController {
    
    // MARK: - Properties
    
    static let shared = ServiceController()
    var services: [Service] = []
    let baseURL = URL(string: "https://sasi-ios.firebaseio.com/")
    
    func updateService(service: Service, serviceIsChosen: Bool? = nil) {
        if let serviceIsChosen = serviceIsChosen {
            service.serviceIsChosen = serviceIsChosen
        }
    }
    
    // MARK: - Fetch Services from Firebase
    
    // GET
    
    func fetchServicesFromFirebase(completion: @escaping() -> Void) {
        
        guard let baseURL = baseURL else { completion(); return }
        let url = baseURL.appendingPathComponent("users").appendingPathComponent("services").appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print(error)
                completion()
                return
            }
            
            guard let data = data else { completion(); return }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else { print("userDiciontary jsonserialization failed"); completion(); return }
            
            let services = jsonDictionary.flatMap( { Service(dictionary: $0.value as! [String : Any]) } )
            
            self.services = services
            
            completion()
        }
        
        dataTask.resume()
    }
}

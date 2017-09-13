//
//  VehicleController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation
import Firebase

class VehicleController {
    
    // MARK: - Properties
    
    static let shared = VehicleController()
    var vehicles: [Vehicle] = []
    var vehicle = Vehicle(year: "", make: "", model: "", prefFuelType: "", prefOilType: "", vehicleUUID: "")
    let baseURL = URL(string: "https://sasi-ios.firebaseio.com/")
    let userID = Auth.auth().currentUser?.uid
    
    // MARK: - CRUD Functions
    
    func createVehicle(year: String, make: String, model: String, prefFuelType: String, prefOilType: String, vehicleUUID: String) {
        let vehicle = Vehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID)
        vehicles.append(vehicle)
        self.vehicle = vehicle
        putVehicleToFirebase(vehicle: vehicle) { (success) in
        }
    }
    
    func updateVehicle(year: String, make: String, model: String, prefFuelType: String, prefOilType: String, vehicleUUID: String) {
        let vehicle = Vehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID)
        self.vehicle = vehicle
        patchVehicleToFirebase(vehicle: vehicle) { (success) in
        }
    }
    
    // MARK: - Firebase API Calls
    
    // GET
    
    func fetchVehiclesFromFirebase(completion: @escaping() -> Void) {
        
        guard let baseURL = baseURL,
            let userID = userID else { completion(); return }
        let url = baseURL.appendingPathComponent("users").appendingPathComponent(userID).appendingPathExtension("json")
        
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
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else { completion(); return }
            
            guard let vehiclesDictionary = jsonDictionary["vehicles"] as? [String: [String: Any]] else { completion(); return }
            
            let vehicles = vehiclesDictionary.flatMap( { Vehicle(dictionary: $0.value) } )
            
            self.vehicles = vehicles
            
            completion()
        }
        
        dataTask.resume()
    }

    // PUT
    
    func putVehicleToFirebase(vehicle: Vehicle, completion: @escaping(Bool) -> Void) {
    
        guard let baseURL = baseURL,
            let userID = userID else { completion(false); return }
        
        let url = baseURL.appendingPathComponent("users").appendingPathComponent(userID).appendingPathComponent("vehicles").appendingPathComponent(vehicle.vehicleUUID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = vehicle.jsonData
        
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
                self.vehicle = vehicle
                completion(true)
                return
            }
        }
        
        dataTask.resume()
    }
    
    // PATCH
    
    func patchVehicleToFirebase(vehicle: Vehicle, completion: @escaping(Bool) -> Void) {
        
        guard let baseURL = baseURL,
            let userID = userID else { completion(false); return }
        
        let url = baseURL.appendingPathComponent("users").appendingPathComponent(userID).appendingPathComponent("vehicles").appendingPathComponent(vehicle.vehicleUUID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = vehicle.jsonData
        
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
                self.vehicle = vehicle
                completion(true)
                return
            }
        }
        
        dataTask.resume()
    }
    
    // DELETE
    
    func deleteVehicleFromFirebase(vehicle: Vehicle, completion: @escaping(Bool) -> Void) {
        
        guard let baseURL = baseURL,
            let userID = userID else { completion(false); return }
        
        let url = baseURL.appendingPathComponent("users").appendingPathComponent(userID).appendingPathComponent("vehicles").appendingPathComponent(vehicle.vehicleUUID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = vehicle.jsonData
        
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
                self.vehicle = vehicle
                completion(true)
                return
            }
        }
        
        dataTask.resume()
    }

}

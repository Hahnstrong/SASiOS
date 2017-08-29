//
//  UserController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    // MARK: - Properties
    
    static let shared = UserController()
    var user: User = User(email: "")
    let baseURL = URL(string: "https://sasi-ios.firebaseio.com/")
    let userID = Auth.auth().currentUser?.uid
    
    // MARK: - CRUD Functions
    
    func createUser(name: String, address: String, phoneNumber: String, gateCode: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        user = User(name: name, address: address, phoneNumber: phoneNumber, email: email, gateCode: gateCode)
    }
    
    // MARK: - Firebase API Calls
    
    // GET
    
    func fetchUserFromFirebase(completion: @escaping() -> Void) {
        
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
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else { print("userDiciontary jsonserialization failed"); completion(); return }
            
            guard let user = User(dictionary: jsonDictionary) else { print("user from userDictionary failed"); completion(); return }
            
            self.user = user
            
            completion()
        }
        
        dataTask.resume()
    }
    
    // PUT
    
    func putUserToFirebase(user: User, completion: @escaping(Bool) -> Void) {
        
        guard let baseURL = baseURL,
            let userID = userID else { completion(false); return }
        
        let url = baseURL.appendingPathComponent("users").appendingPathComponent(userID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = user.jsonData
        
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
                UserController.shared.user = user
                completion(true)
                return
            }
        }
        
        dataTask.resume()
    }
}

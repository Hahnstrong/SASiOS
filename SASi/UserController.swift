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
    
    static let shared = UserController()

    var user: User = User(userID: "", email: "")
    
    // MARK: - CRUD Functions
    
    func createUser(name: String, address: String, phoneNumber: String, gateCode: String) {
        guard let userID = Auth.auth().currentUser?.uid,
            let email = Auth.auth().currentUser?.email else { return }
        self.user = User(userID: userID, name: name, address: address, phoneNumer: phoneNumber, email: email, gateCode: gateCode)
    }
    
    // MARK: - Firebase API Calls
    
    static let baseURL = URL(string: "https://sasi-ios.firebaseio.com/")
    
    // GET
    
    
    
    
    // POST
    
    static func postUserToFirebase(user: User, completion: @escaping(Bool) -> Void) {
        
        guard let baseURL = baseURL else { completion(false); return }
        let url = baseURL.appending
        
        
    }
    
}

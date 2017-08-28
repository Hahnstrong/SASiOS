//
//  LoginViewController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        if segmentControl.selectedSegmentIndex == 1 {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if user != nil {
                    self.createUserAlert()
                } else {
                    print("Error: \(String(describing: error))")
                }
            }
        }
            
        else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "ToVehicleList", sender: self)
                } else {
                    print("Error: \(String(describing: error))")
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    func createUserAlert() {
        let createUserAlert = UIAlertController(title: "Please fill in the required user data.", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        var addressTextField: UITextField?
        var phoneNumberTextField: UITextField?
        var gateCodeTextField: UITextField?
        
        createUserAlert.addTextField { (nameField) in
            nameField.placeholder = "Enter your name here..."
            nameTextField = nameField
        }
        
        createUserAlert.addTextField { (addressField) in
            addressField.placeholder = "Enter your address here..."
            addressTextField = addressField
        }
        
        createUserAlert.addTextField { (phoneNumberField) in
            phoneNumberField.placeholder = "Enter your phone number here..."
            phoneNumberTextField = phoneNumberField
        }
        
        createUserAlert.addTextField { (gateCodeField) in
            gateCodeField.placeholder = "Enter your gate code here..."
            gateCodeTextField = gateCodeField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            guard let name = nameTextField?.text, name != "",
                let address = addressTextField?.text, address != "",
                let phoneNumber = phoneNumberTextField?.text, phoneNumber != "",
                let gateCode = gateCodeTextField?.text else { return }
            
            UserController.shared.createUser(name: name, address: address, phoneNumber: phoneNumber, gateCode: gateCode)
            self.performSegue(withIdentifier: "ToVehicleList", sender: self)
        }
        
        createUserAlert.addAction(cancelAction)
        createUserAlert.addAction(createAction)
        
        present(createUserAlert, animated: true, completion: nil)

        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}


























//
//  LoginViewController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func backArrow(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        if segmentControl.selectedSegmentIndex == 1 {
            
            loginButton.titleLabel?.text = "Signup"
            
            // Create User
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if user != nil {
                    UserController.shared.createUserWithEmail()
                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "user_uid_key")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "ToVehicleListFromEmailLogin", sender: self)
                } else {
                    guard let error = error else { return }
                    self.signInErrorAlert(error: error)
                }
            }
        }
            
        else {
            
            // Signin User
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if user != nil {
                    UserController.shared.fetchUserFromFirebase(completion: {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "ToVehicleListFromEmailLogin", sender: self)
                        }
                    })
                } else {
                    guard let error = error else { return }
                    self.signInErrorAlert(error: error)
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    func signInErrorAlert(error: Error) {
        let signInErrorAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        signInErrorAlertController.addAction(cancelButton)
        
        present(signInErrorAlertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}





















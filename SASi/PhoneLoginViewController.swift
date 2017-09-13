//
//  PhoneLoginViewController.swift
//  SASi
//
//  Created by Caleb Strong on 9/11/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneLoginViewController: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumberTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func backArrow(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func phoneLoginButton(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        var verificationID: String?
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber) { (verID, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "")")
            } else {
                guard let verID = verID else { return }
                verificationID = verID
                self.codeAuthAlert(verificationID: verificationID!)
            }
            
        }
    }
    
    // MARK: - Alerts
    
    func codeAuthAlert(verificationID: String) {
        let codeAuthAlert = UIAlertController(title: "Verification Code", message: nil, preferredStyle: .alert)
        
        var codeTextField: UITextField?
        
        codeAuthAlert.addTextField { (codeField) in
            codeTextField = codeField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (UIAlertAction) in
            guard let code = codeTextField?.text, code != "" else { return }
            let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription ?? "")")
                } else {
                    print("Phone Number: \(user?.phoneNumber ?? "")")
                    let userInfo = user?.providerData[0]
                    print("Provider ID: \(userInfo?.providerID ?? "")")
                    UserController.shared.createUserWithPhone()
                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "user_uid_key")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "ToVehicleListFromPhoneLogin", sender: self)
                }
            })
        }
        
        codeAuthAlert.addAction(cancelAction)
        codeAuthAlert.addAction(enterAction)
        
        present(codeAuthAlert, animated: true, completion: nil)
    }
}

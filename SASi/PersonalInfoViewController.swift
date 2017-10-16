//
//  PersonalInfoViewController.swift
//  SASi
//
//  Created by Caleb Strong on 9/13/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController, UITextFieldDelegate {

    var user = UserController.shared.user
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var gateCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func backArrowTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField?.text,
            let address = addressTextField?.text,
            let phoneNumber = phoneNumberTextField?.text,
            let gateCode = gateCodeTextField?.text,
            let email = emailTextField?.text else { return }
        
        self.user.name = name
        self.user.address = address
        self.user.phoneNumber = phoneNumber
        self.user.gateCode = gateCode
        self.user.email = email
        
        UserController.shared.patchUserToFirebase(user: self.user, completion: { (success) in
        })
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Text Field Delegate
    	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    // MARK: - View Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        nameTextField.tag = 0
        addressTextField.delegate = self
        addressTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        gateCodeTextField.delegate = self
        gateCodeTextField.tag = 3
        phoneNumberTextField.delegate = self
        phoneNumberTextField.tag = 4

        nameTextField.text = user.name
        addressTextField.text = user.address
        emailTextField.text = user.email
        gateCodeTextField.text = user.gateCode
        phoneNumberTextField.text = user.phoneNumber
    }

    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, at: 0)
        
        saveButton.layer.cornerRadius = 8
    }
}

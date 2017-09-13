//
//  WelcomeViewController.swift
//  SASi
//
//  Created by Caleb Strong on 9/11/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, at: 0)
        
        signInWithEmail.layer.cornerRadius = 8
        signInWithPhone.layer.cornerRadius = 8
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - IBOutlets
    
    @IBOutlet weak var signInWithPhone: UIButton!
    @IBOutlet weak var signInWithEmail: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func signInWithEmail(_ sender: Any) {
        checkForAuthenticatedUser(whichLogin: "ToEmailLogin")
    }
    
    @IBAction func signInWithPhone(_ sender: Any) {
        checkForAuthenticatedUser(whichLogin: "ToPhoneLogin")
    }
    
    func checkForAuthenticatedUser(whichLogin: String) {
        if UserDefaults.standard.object(forKey: "user_uid_key") != nil {
            UserController.shared.fetchUserFromFirebase(completion: {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VehicleListVC = storyboard.instantiateViewController(withIdentifier: "VehicleListTableViewController")
                    self.navigationController?.pushViewController(VehicleListVC, animated: true)
                }
            })
        } else {
            self.performSegue(withIdentifier: whichLogin, sender: self)
        }
    }
}

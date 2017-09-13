//
//  ServiceListTableViewController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ServiceListTableViewController: UITableViewController, ServiceTableViewCellDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    var totalPrice: Int = 75
    var vehicle: Vehicle?
    var user = UserController.shared.user
    var buttonArray: [DayButton] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var mondayButton: DayButton!
    @IBOutlet weak var tuesdayButton: DayButton!
    @IBOutlet weak var wednesdayButton: DayButton!
    @IBOutlet weak var thursdayButton: DayButton!
    @IBOutlet weak var fridayButton: DayButton!
    
    // MARK: - IBActions
    
    @IBAction func mondayButtonTapped(_ sender: Any) {
        buttonArray = dayButtonWasSelected(clickedButton: mondayButton)
    }
    
    @IBAction func tuesdayButtonTapped(_ sender: Any) {
        buttonArray = dayButtonWasSelected(clickedButton: tuesdayButton)
    }
    
    @IBAction func wednesdayButtonTapped(_ sender: Any) {
        buttonArray = dayButtonWasSelected(clickedButton: wednesdayButton)
    }
    
    @IBAction func thursdayButtonTapped(_ sender: Any) {
        buttonArray = dayButtonWasSelected(clickedButton: thursdayButton)
    }
    
    @IBAction func fridayButtonTapped(_ sender: Any) {
        buttonArray = dayButtonWasSelected(clickedButton: fridayButton)
    }
    
    @IBAction func backArrow(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func placeOrderButtonTapped(_ sender: Any) {
        
        if user.address == "" || user.email == "" || user.name == "" || user.gateCode == "" || user.phoneNumber == "" {
            self.updateUserInfoAlert()
        } else if buttonArray == [] {
            let noDaySelectedAlert = UIAlertController(title: "Please Select a Day", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            noDaySelectedAlert.addAction(okAction)
            present(noDaySelectedAlert, animated: true, completion: nil)
        } else {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServiceController.shared.fetchServicesFromFirebase(completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        totalPriceLabel?.text = "$\(totalPrice)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        placeOrderButton.layer.cornerRadius = 8
        mondayButton.layer.cornerRadius = 8
        tuesdayButton.layer.cornerRadius = 8
        wednesdayButton.layer.cornerRadius = 8
        thursdayButton.layer.cornerRadius = 8
        fridayButton.layer.cornerRadius = 8
        
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceController.shared.services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        let service = ServiceController.shared.services[indexPath.row]
        
        cell.service = service
        cell.serviceView.layer.cornerRadius = 8
        cell.selectionStyle = .none
        
        return cell
    }
    
    func dayButtonWasSelected(clickedButton: DayButton) -> [DayButton] {
        let buttonArray: [DayButton] = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton]
        for button in buttonArray {
            if button != clickedButton {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
        }
        
        return buttonArray
    }
    
    func serviceWasSelected(cell: ServiceTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let service = ServiceController.shared.services[indexPath.row]
        let willBeChosen = !service.serviceIsChosen
        
        if willBeChosen == true {
            self.totalPrice = totalPrice + service.servicePrice
        } else {
            self.totalPrice = totalPrice - service.servicePrice
        }
        
        totalPriceLabel?.text = "$\(self.totalPrice)"
        
        ServiceController.shared.updateService(service: service, serviceIsChosen: willBeChosen)
        
        cell.service = service
    }
    
    // MARK: - Alerts
    
    func updateUserInfoAlert() {
        let updateUserAlert = UIAlertController(title: "Please fill in all spaces", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        var addressTextField: UITextField?
        var phoneNumberTextField: UITextField?
        var gateCodeTextField: UITextField?
        var emailTextField: UITextField?
        
        updateUserAlert.addTextField { (nameField) in
            nameField.placeholder = "Enter your name here..."
            nameField.text = self.user.name
            nameTextField = nameField
        }
        
        updateUserAlert.addTextField { (addressField) in
            addressField.placeholder = "Enter your address here..."
            addressField.text = self.user.address
            addressTextField = addressField
        }
        
        updateUserAlert.addTextField { (phoneNumberField) in
            phoneNumberField.placeholder = "Enter your phone number here..."
            phoneNumberField.text = self.user.phoneNumber
            phoneNumberTextField = phoneNumberField
        }
        
        updateUserAlert.addTextField { (gateCodeField) in
            gateCodeField.placeholder = "Enter your gate code here..."
            gateCodeField.text = self.user.gateCode
            gateCodeTextField = gateCodeField
        }
        
        updateUserAlert.addTextField { (emailField) in
            emailField.placeholder = "Enter your email here..."
            emailField.text = self.user.email
            emailTextField = emailField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let name = nameTextField?.text, name != "",
                let address = addressTextField?.text, address != "",
                let phoneNumber = phoneNumberTextField?.text, phoneNumber != "",
                let gateCode = gateCodeTextField?.text,
                let email = emailTextField?.text, email != "" else { return }
            
            self.user.name = name
            self.user.address = address
            self.user.phoneNumber = phoneNumber
            self.user.gateCode = gateCode
            self.user.email = email
            
            UserController.shared.patchUserToFirebase(user: self.user, completion: { (success) in
            })
            
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
        
        updateUserAlert.addAction(cancelAction)
        updateUserAlert.addAction(saveAction)
        
        present(updateUserAlert, animated: true, completion: nil)
    }
    
    // MARK: - Email Controller
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let user = UserController.shared.user
        let vehicle = self.vehicle
        let services = ServiceController.shared.services
        var dayChosen = "No day was chosen"
        
        for button: DayButton in buttonArray {
            if button.isEnabled == false {
                switch button {
                case mondayButton:
                    dayChosen = "Monday"
                case tuesdayButton:
                    dayChosen = "Tuesday"
                case wednesdayButton:
                    dayChosen = "Wednesday"
                case thursdayButton:
                    dayChosen = "Thursday"
                case fridayButton:
                    dayChosen = "Friday"
                default:
                    dayChosen = "No day was chosen"
                }
            }
        }
        
        var servicesOrdered = ""
        
        for service in services {
            if service.serviceIsChosen == true {
                if servicesOrdered == "" {
                    servicesOrdered = servicesOrdered + service.serviceName
                } else {
                    servicesOrdered = servicesOrdered + ", " + service.serviceName
                }
            }
        }
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["sasi.ordered.services@gmail.com", "\(user.email ?? "")"])
        mailComposerVC.setSubject("Service order from \(user.name ?? ""), \(user.phoneNumber ?? "").")
        mailComposerVC.setMessageBody("Vehicle to be serviced: \(vehicle?.year ?? "") \(vehicle?.make ?? "") \(vehicle?.model ?? ""). Services ordered: \(servicesOrdered). The vehicle will be serviced on \(dayChosen). And the total price is $\(totalPrice). The address to pickup and dropoff car is \(user.address ?? ""), and the gate code is \(user.gateCode ?? ""). Comments: ", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//
//  ServiceOrderViewController.swift
//  SASi
//
//  Created by Caleb Strong on 9/21/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ServiceOrderViewController: UIViewController, ServiceTableViewCellDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

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
    @IBOutlet weak var serviceListTableView: UITableView!
    
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
            
            let missingInfoAlert = UIAlertController(title: "Please fill in all fields", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                self.performSegue(withIdentifier: "ToPersonalInfoView", sender: self)
            })
            missingInfoAlert.addAction(cancelAction)
            missingInfoAlert.addAction(okayAction)
            present(missingInfoAlert, animated: true, completion: nil)
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
                self.serviceListTableView.reloadData()
            }
        })
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        totalPriceLabel?.text = "$\(totalPrice)"
        serviceListTableView.delegate = self
        serviceListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        serviceListTableView.tableFooterView = UIView(frame: .zero)
        serviceListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        placeOrderButton.layer.cornerRadius = 8
        mondayButton.layer.cornerRadius = 8
        tuesdayButton.layer.cornerRadius = 8
        wednesdayButton.layer.cornerRadius = 8
        thursdayButton.layer.cornerRadius = 8
        fridayButton.layer.cornerRadius = 8
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, at: 0)
        
        let backgroundImageForTV = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImageForTV)
        imageView.contentMode = .scaleAspectFill
        serviceListTableView.backgroundView = imageView
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceController.shared.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    // MARK: - ServiceTableViewCell Delegate Function
    
    func serviceWasSelected(cell: ServiceTableViewCell) {
        guard let indexPath = serviceListTableView.indexPath(for: cell) else { return }
        
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
        let orderSentAlert = UIAlertController(title: "Order was complete", message: nil, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel) { (UIAlertAction) in
            
            var dayChosen = "No day was chosen"
            let services = ServiceController.shared.services
            
            for button: DayButton in self.buttonArray {
                if button.isEnabled == false {
                    switch button {
                    case self.mondayButton:
                        dayChosen = "Monday"
                    case self.tuesdayButton:
                        dayChosen = "Tuesday"
                    case self.wednesdayButton:
                        dayChosen = "Wednesday"
                    case self.thursdayButton:
                        dayChosen = "Thursday"
                    case self.fridayButton:
                        dayChosen = "Friday"
                    default:
                        dayChosen = "No day was chosen"
                    }
                }
            }
            
            var servicesOrdered: String = ""
            
            for service in services {
                if service.serviceIsChosen == true {
                    servicesOrdered = servicesOrdered + ", " + service.serviceName
                }
            }
            let orderUUID = UUID().uuidString
            guard let vehicle = self.vehicle else { return }
            let vehicleName: String = vehicle.year + " " + vehicle.make + " " + vehicle.model
        
            OrderController.shared.createOrder(date: dayChosen, price: self.totalPrice, services: servicesOrdered, vehicle: vehicleName, isCompleted: false, orderUUID: orderUUID)
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        
        orderSentAlert.addAction(okayAction)
        
        controller.dismiss(animated: true, completion: nil)
        
        present(orderSentAlert, animated: true, completion: nil)
    }
}

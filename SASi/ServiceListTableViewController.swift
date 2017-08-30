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
    
    var totalPrice: Int = 0
    var vehicle: Vehicle?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func placeOrderButtonTapped(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let user = UserController.shared.user
        let vehicle = self.vehicle
        let services = ServiceController.shared.services
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
        
        mailComposerVC.setToRecipients(["stronggarner66@gmail.com", "stronghawke@gmail.com", "\(user.email)"])
        mailComposerVC.setSubject("Service order from \(user.name ?? "")")
        mailComposerVC.setMessageBody("Vehicle to be serviced: \(vehicle?.year ?? "") \(vehicle?.make ?? "") \(vehicle?.model ?? ""). Services ordered: \(servicesOrdered). And the total price is $\(totalPrice). Comments: ", isHTML: false)
        
        return mailComposerVC
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
        
        placeOrderButton.layer.cornerRadius = 8
        
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ServiceController.shared.services.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        let service = ServiceController.shared.services[indexPath.section]
        
        cell.service = service
        cell.layer.cornerRadius = 8
        
        return cell
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

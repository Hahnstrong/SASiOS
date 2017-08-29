//
//  VehicleListTableViewController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit

class VehicleListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var user = UserController.shared.user
    
    // MARK: - IBActions
    
    @IBAction func personalInfoButtonTapped(_ sender: Any) {
        updateUserInfoAlert()
    }
    
    @IBAction func addVehicleButtonTapped(_ sender: Any) {
        createVehicleAlert()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        VehicleController.shared.fetchVehiclesFromFirebase { 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VehicleController.shared.vehicles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath)

        let vehicle = VehicleController.shared.vehicles[indexPath.row]
        cell.textLabel?.text = "\(vehicle.year) \(vehicle.make) \(vehicle.model)"
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToServiceView" {
            if let destinationViewController = segue.destination as? ServiceListTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let vehicle = VehicleController.shared.vehicles[indexPath.row]
                    destinationViewController.vehicle = vehicle
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    func updateUserInfoAlert() {
        let createUserAlert = UIAlertController(title: "Your user info", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        var addressTextField: UITextField?
        var phoneNumberTextField: UITextField?
        var gateCodeTextField: UITextField?
        
        createUserAlert.addTextField { (nameField) in
            nameField.placeholder = "Enter your name here..."
            nameField.text = self.user.name
            nameTextField = nameField
        }
        
        createUserAlert.addTextField { (addressField) in
            addressField.placeholder = "Enter your address here..."
            addressField.text = self.user.address
            addressTextField = addressField
        }
        
        createUserAlert.addTextField { (phoneNumberField) in
            phoneNumberField.placeholder = "Enter your phone number here..."
            phoneNumberField.text = self.user.phoneNumber
            phoneNumberTextField = phoneNumberField
        }
        
        createUserAlert.addTextField { (gateCodeField) in
            gateCodeField.placeholder = "Enter your gate code here..."
            gateCodeField.text = self.user.gateCode
            gateCodeTextField = gateCodeField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let name = nameTextField?.text, name != "",
                let address = addressTextField?.text, address != "",
                let phoneNumber = phoneNumberTextField?.text, phoneNumber != "",
                let gateCode = gateCodeTextField?.text else { return }
            
//            UserController.postUserToFirebase(user: <#T##User#>, completion: <#T##(Bool) -> Void#>)
        }
        
        createUserAlert.addAction(cancelAction)
        createUserAlert.addAction(saveAction)
        
        present(createUserAlert, animated: true, completion: nil)
    }
    
    func createVehicleAlert() {
        let createVehicleAlert = UIAlertController(title: "Add a vehicle below.", message: nil, preferredStyle: .alert)
        
        var yearTextField: UITextField?
        var makeTextField: UITextField?
        var modelTextField: UITextField?
        var prefFuelTypeTextField: UITextField?
        var prefOilTypeTextField: UITextField?
        
        createVehicleAlert.addTextField { (yearField) in
            yearField.placeholder = "Enter your vehicles year..."
            yearTextField = yearField
        }
        
        createVehicleAlert.addTextField { (makeField) in
            makeField.placeholder = "Enter your vehicles make..."
            makeTextField = makeField
        }
        
        createVehicleAlert.addTextField { (modelField) in
            modelField.placeholder = "Enter your vehicles model..."
            modelTextField = modelField
        }
        
        createVehicleAlert.addTextField { (prefFuelField) in
            prefFuelField.placeholder = "Enter your vehicles preffered fuel type..."
            prefFuelTypeTextField = prefFuelField
        }
        
        createVehicleAlert.addTextField { (prefOilField) in
            prefOilField.placeholder = "Enter your vehicles preffered oil type..."
            prefOilTypeTextField = prefOilField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let year = yearTextField?.text, year != "",
                let make = makeTextField?.text, make != "",
                let model = modelTextField?.text, model != "",
                let prefFuelType = prefFuelTypeTextField?.text,
                let prefOilType = prefOilTypeTextField?.text else { return }
            
            VehicleController.shared.createVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType)
            let vehicle = VehicleController.shared.vehicle
            VehicleController.shared.postVehicleToFirebase(vehicle: vehicle, completion: { (success) in
                print("Succes!")
            })
            self.tableView.reloadData()
        }
        
        createVehicleAlert.addAction(cancelAction)
        createVehicleAlert.addAction(saveAction)
        
        present(createVehicleAlert, animated: true, completion: nil)
    }
}

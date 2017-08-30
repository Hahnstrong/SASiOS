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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var personalInfoButton: UIButton!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView(frame: .zero)
        
        personalInfoButton.layer.cornerRadius = 8
        
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
        return VehicleController.shared.vehicles.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath)

        let vehicle = VehicleController.shared.vehicles[indexPath.section]
        cell.textLabel?.text = "\(vehicle.year) \(vehicle.make) \(vehicle.model)"
        cell.layer.cornerRadius = 8
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let vehicle = VehicleController.shared.vehicles[indexPath.row]
            VehicleController.shared.deleteVehicleFromFirebase(vehicle: vehicle, completion: { (success) in
            })
            VehicleController.shared.vehicles.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = VehicleController.shared.vehicles[indexPath.row]
        updateVehicleAlert(vehicle: vehicle)
    }

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
        let updateUserAlert = UIAlertController(title: "Your user info", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        var addressTextField: UITextField?
        var phoneNumberTextField: UITextField?
        var gateCodeTextField: UITextField?
        
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let name = nameTextField?.text, name != "",
                let address = addressTextField?.text, address != "",
                let phoneNumber = phoneNumberTextField?.text, phoneNumber != "",
                let gateCode = gateCodeTextField?.text else { return }
            
            self.user.name = name
            self.user.address = address
            self.user.phoneNumber = phoneNumber
            self.user.gateCode = gateCode
            
            UserController.shared.patchUserToFirebase(user: self.user, completion: { (success) in
            })
        }
        
        updateUserAlert.addAction(cancelAction)
        updateUserAlert.addAction(saveAction)
        
        present(updateUserAlert, animated: true, completion: nil)
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
            let vehicleUUID = UUID().uuidString
            
            VehicleController.shared.createVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID)
            let vehicle = VehicleController.shared.vehicle
            VehicleController.shared.putVehicleToFirebase(vehicle: vehicle, completion: { (success) in
            })
            self.tableView.reloadData()
        }
        
        createVehicleAlert.addAction(cancelAction)
        createVehicleAlert.addAction(saveAction)
        
        present(createVehicleAlert, animated: true, completion: nil)
    }
    
    func updateVehicleAlert(vehicle: Vehicle) {
        let updateVehicleAlert = UIAlertController(title: "Vehicle Info", message: nil, preferredStyle: .alert)
        
        var yearTextField: UITextField?
        var makeTextField: UITextField?
        var modelTextField: UITextField?
        var prefFuelTypeTextField: UITextField?
        var prefOilTypeTextField: UITextField?
        
        updateVehicleAlert.addTextField { (yearField) in
            yearField.placeholder = "Enter your vehicles year..."
            yearField.text = vehicle.year
            yearTextField = yearField
        }
        
        updateVehicleAlert.addTextField { (makeField) in
            makeField.placeholder = "Enter your vehicles make..."
            makeField.text = vehicle.make
            makeTextField = makeField
        }
        
        updateVehicleAlert.addTextField { (modelField) in
            modelField.placeholder = "Enter your vehicles model..."
            modelField.text = vehicle.model
            modelTextField = modelField
        }
        
        updateVehicleAlert.addTextField { (prefFuelField) in
            prefFuelField.placeholder = "Enter your vehicles preffered fuel type..."
            prefFuelField.text = vehicle.prefFuelType
            prefFuelTypeTextField = prefFuelField
        }
        
        updateVehicleAlert.addTextField { (prefOilField) in
            prefOilField.placeholder = "Enter your vehicles preffered oil type..."
            prefOilField.text = vehicle.prefOilType
            prefOilTypeTextField = prefOilField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let year = yearTextField?.text, year != "",
                let make = makeTextField?.text, make != "",
                let model = modelTextField?.text, model != "",
                let prefFuelType = prefFuelTypeTextField?.text,
                let prefOilType = prefOilTypeTextField?.text else { return }
            let vehicleUUID = vehicle.vehicleUUID
            
            VehicleController.shared.updateVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID)
            let vehicle = VehicleController.shared.vehicle
            VehicleController.shared.patchVehicleToFirebase(vehicle: vehicle, completion: { (success) in
            })
            VehicleController.shared.fetchVehiclesFromFirebase(completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        let orderServicesAction = UIAlertAction(title: "Order Services", style: .default) { (_) in
            guard let year = yearTextField?.text, year != "",
                let make = makeTextField?.text, make != "",
                let model = modelTextField?.text, model != "",
                let prefFuelType = prefFuelTypeTextField?.text,
                let prefOilType = prefOilTypeTextField?.text else { return }
            let vehicleUUID = vehicle.vehicleUUID
            
            VehicleController.shared.updateVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID)
            let vehicle = VehicleController.shared.vehicle
            VehicleController.shared.patchVehicleToFirebase(vehicle: vehicle, completion: { (success) in
            })
            self.performSegue(withIdentifier: "ToServiceView", sender: self)
        }
        
        updateVehicleAlert.addAction(cancelAction)
        updateVehicleAlert.addAction(saveAction)
        updateVehicleAlert.addAction(orderServicesAction)
        
        present(updateVehicleAlert, animated: true, completion: nil)
    }
}

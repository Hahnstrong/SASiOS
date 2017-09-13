//
//  VehicleInfoViewController.swift
//  SASi
//
//  Created by Caleb Strong on 9/13/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit

class VehicleInfoViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var vehicle: Vehicle?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var vehicleYearTextField: UITextField!
    @IBOutlet weak var vehicleMakeTextField: UITextField!
    @IBOutlet weak var vehicleModelTextField: UITextField!
    @IBOutlet weak var vehiclePrefFuelTypeTextField: UITextField!
    @IBOutlet weak var vehiclePrefOilTypeTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func backArrowTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orderServicesButtonTapped(_ sender: Any) {
        
        guard let year = vehicleYearTextField?.text, year != "",
            let make = vehicleMakeTextField?.text, make != "",
            let model = vehicleModelTextField?.text, model != "",
            let prefFuelType = vehiclePrefFuelTypeTextField?.text,
            let prefOilType = vehiclePrefOilTypeTextField?.text else { return }
        var vehicleUUID = vehicle?.vehicleUUID
        
        if vehicle != nil {
            VehicleController.shared.updateVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID!)
            
            self.performSegue(withIdentifier: "ToServiceView", sender: self)
        } else {
            vehicleUUID = UUID().uuidString
            
            VehicleController.shared.createVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID!)
            
            self.performSegue(withIdentifier: "ToServiceView", sender: self)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let year = vehicleYearTextField?.text, year != "",
            let make = vehicleMakeTextField?.text, make != "",
            let model = vehicleModelTextField?.text, model != "",
            let prefFuelType = vehiclePrefFuelTypeTextField?.text,
            let prefOilType = vehiclePrefOilTypeTextField?.text else { return }
        var vehicleUUID = vehicle?.vehicleUUID
        
        if vehicle != nil {
            VehicleController.shared.updateVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID!)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            vehicleUUID = UUID().uuidString
            
            VehicleController.shared.createVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID!)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        vehicleYearTextField.resignFirstResponder()
        vehicleMakeTextField.resignFirstResponder()
        vehicleModelTextField.resignFirstResponder()
        vehiclePrefFuelTypeTextField.resignFirstResponder()
        vehiclePrefOilTypeTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - View Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehicleYearTextField.delegate = self
        vehicleMakeTextField.delegate = self
        vehicleModelTextField.delegate = self
        vehiclePrefFuelTypeTextField.delegate = self
        vehiclePrefOilTypeTextField.delegate = self
        
        if vehicle != nil {
            vehicleYearTextField.text = vehicle?.year
            vehicleMakeTextField.text = vehicle?.make
            vehicleModelTextField.text = vehicle?.model
            vehiclePrefFuelTypeTextField.text = vehicle?.prefFuelType
            vehiclePrefOilTypeTextField.text = vehicle?.prefOilType
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToServiceView" {
            if let destinationViewController = segue.destination as? ServiceListTableViewController {
                let vehicle = VehicleController.shared.vehicle
                destinationViewController.vehicle = vehicle
            }
        }
    }
    
}

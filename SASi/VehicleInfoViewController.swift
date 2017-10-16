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
    @IBOutlet weak var orderServicesForThisVehicleButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
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
        } else {
            vehicleUUID = UUID().uuidString
            
            VehicleController.shared.createVehicle(year: year, make: make, model: model, prefFuelType: prefFuelType, prefOilType: prefOilType, vehicleUUID: vehicleUUID!)
        }
        
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
        
        vehicleYearTextField.delegate = self
        vehicleYearTextField.tag = 0
        vehicleMakeTextField.delegate = self
        vehicleMakeTextField.tag = 1
        vehicleModelTextField.delegate = self
        vehicleModelTextField.tag = 2
        vehiclePrefFuelTypeTextField.delegate = self
        vehiclePrefFuelTypeTextField.tag = 3
        vehiclePrefOilTypeTextField.delegate = self
        vehiclePrefOilTypeTextField.tag = 4
        
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
        
        orderServicesForThisVehicleButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToServiceView" {
            if let destinationViewController = segue.destination as? ServiceOrderViewController {
                let vehicle = VehicleController.shared.vehicle
                destinationViewController.vehicle = vehicle
            }
        }
    }
    
}

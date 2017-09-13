//
//  VehicleListTableViewController.swift
//  SASi
//
//  Created by Caleb Strong on 8/28/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit
import FirebaseAuth

class VehicleListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var user = UserController.shared.user
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var personalInfoButton: UIButton!
    @IBOutlet weak var addVehicleButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func backArrow(_ sender: Any) {
//        try! Auth.auth().signOut()
//        UserDefaults.standard.removeObject(forKey: "user_uid_key")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func personalInfoButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ToPersonalInfoView", sender: self)
    }
    
    @IBAction func addVehicleButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ToVehicleInfoView", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        VehicleController.shared.fetchVehiclesFromFirebase {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        personalInfoButton.layer.cornerRadius = 8
        addVehicleButton.layer.cornerRadius = 8
        
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
        return VehicleController.shared.vehicles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as? VehicleTableViewCell else { return UITableViewCell() }
        
        let vehicle = VehicleController.shared.vehicles[indexPath.row]
        
        cell.vehicleLabel.text = "\(vehicle.year) \(vehicle.make) \(vehicle.model)"
        cell.vehicleView.layer.cornerRadius = 8
        cell.selectionStyle = .none
        
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
        self.performSegue(withIdentifier: "ToVehicleInfoView", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToVehicleInfoView" {
            if let destinationViewController = segue.destination as? VehicleInfoViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let vehicle = VehicleController.shared.vehicles[indexPath.row]
                    destinationViewController.vehicle = vehicle
                }
            }
        }
    }
}

//
//  ServiceTableViewCell.swift
//  SASi
//
//  Created by Caleb Strong on 8/29/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var serviceChosenButton: UIButton!
    @IBOutlet weak var serviceView: UIView!
    
    // MARK: - Actions
    
    @IBAction func serviceIsChosenButtonTapped(_ sender: Any) {
        delegate?.serviceWasSelected(cell: self)
    }
    
    // MARK: - Properties and UpdateView
    
    var service: Service? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        guard let service = service else { return }
        
        serviceNameLabel.text = service.serviceName
        servicePriceLabel.text = "$\(service.servicePrice)"
        let image = service.serviceIsChosen ? #imageLiteral(resourceName: "complete") : #imageLiteral(resourceName: "incomplete")
        serviceChosenButton.setImage(image, for: .normal)
    }
    
    // MARK: - Delegate
    
    weak var delegate: ServiceTableViewCellDelegate?
}

// MARK: - Delegate Protocol

protocol ServiceTableViewCellDelegate: class {
    func serviceWasSelected(cell: ServiceTableViewCell)
}

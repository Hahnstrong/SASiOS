//
//  DayButton.swift
//  SASi
//
//  Created by Caleb Strong on 9/12/17.
//  Copyright © 2017 Caleb Strong. All rights reserved.
//

import UIKit

class DayButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor(red: 60/255.0, green: 134/255.0, blue: 179/255.0, alpha: 1.0) : UIColor.lightGray
        }
    }
}

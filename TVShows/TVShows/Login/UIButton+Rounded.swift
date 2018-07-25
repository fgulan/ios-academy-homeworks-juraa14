//
//  UIButton+Rounded.swift
//  TVShows
//
//  Created by Infinum Student Academy on 19/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import Foundation
import UIKit


extension UIButton{
    
    func roundedButton(){
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

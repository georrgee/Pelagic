//  RegistrationModel.swift
//  Pelagic
//  Created by George Garcia on 6/27/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class RegistrationViewModel {
    
    var fullName: String? { didSet{ checkFormValidity() }}
    var email:    String? { didSet{ checkFormValidity() }}
    var password: String? { didSet{ checkFormValidity() }}
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    // Reactive programming
    var isFormValidObserver: ((Bool)->())?
}

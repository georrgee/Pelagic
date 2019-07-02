//  Bindable.swift
//  Pelagic
//  Created by George Garcia on 7/1/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}

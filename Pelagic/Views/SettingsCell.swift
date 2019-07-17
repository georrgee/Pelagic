//
//  SettingsCell.swift
//  Pelagic
//
//  Created by George Garcia on 7/17/19.
//  Copyright © 2019 GeeTeam. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let textField: UITextField = {
        let textField = SettingsTextField()
        textField.placeholder = "Enter Name"
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SettingsTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
    
}

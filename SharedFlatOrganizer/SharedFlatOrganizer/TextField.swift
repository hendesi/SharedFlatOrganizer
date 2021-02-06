//
//  TextField.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 30.08.20.
//  Copyright © 2020 Felix Desiderato. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
   private let superLabel = UILabel().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    })
    
    private let subLabel = UILabel().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    })
    
    private let underline = UIView().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
    })
    
    var superText: String = "Username" {
        didSet {
            superLabel.text = superText
        }
    }
    
    var subText: String = "Hint: Only needed for registration" {
        didSet {
            subLabel.text = subText
        }
    }
    
    override var isEnabled: Bool {
        set {
            clearButtonMode = newValue ? .always : .never
            super.isEnabled = newValue
        }
        get { return super.isEnabled }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {

        clearButtonMode = .always
        font = .systemFont(ofSize: 18, weight: .medium)
        addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)

        
        heightAnchor.constraint(equalToConstant: 50).activate()
        
        addSubview(underline)
        underline.topAnchor.constraint(equalTo: bottomAnchor, constant: -7).activate()
        underline.heightAnchor.constraint(equalToConstant: 2).activate()
        underline.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        underline.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        
        addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: underline.bottomAnchor, constant: 2).activate()
        subLabel.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        subLabel.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        
        addSubview(superLabel)
        superLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 0).activate()
        superLabel.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        superLabel.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        
    }
    
    @objc func textFieldDidBeginEditing(_ textfield: UITextField) {
        underline.backgroundColor = ColorCatalog.primaryColor
        superLabel.textColor = .darkGray
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        underline.backgroundColor = .lightGray
        superLabel.textColor = .lightGray
    }
}

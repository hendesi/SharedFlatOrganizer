//
//  Button.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 29.08.20.
//  Copyright © 2020 Felix Desiderato. All rights reserved.
//

import UIKit

let ButtonHeight: CGFloat = 50

class Button: UIButton {
    
    var image = UIImage(named: "phoneIcon")?.withRenderingMode(.alwaysOriginal) {
        didSet {
            self.setImage(image?.withTintColor(.white), for: .normal)
            if image != nil { centerTextAndImage(spacing: spacing) }
        }
    }
    
    var title: String = "Register" {
        didSet {
            self.setTitle(title, for: .normal)
            centerTextAndImage(spacing: spacing)

        }
    }
    
    var spacing: CGFloat = 10 {
        didSet {
            centerTextAndImage(spacing: spacing)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(withTitle title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        setup()
    }
    
    private func setup() {
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.tintColor = .white
        self.backgroundColor = ColorCatalog.primaryColor
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-32).isActive = true
        self.heightAnchor.constraint(equalToConstant: ButtonHeight).isActive = true
        
    }
    
    private func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    private func updateUI() {
        if !isEnabled {
            backgroundColor = .lightGray
            tintColor = .darkGray
        } else {
            backgroundColor = ColorCatalog.primaryColor
            tintColor = .white
        }
    }
}

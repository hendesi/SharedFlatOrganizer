//
//  TaskTag.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 25.01.21.
//

import Foundation
import UIKit

class TaskTag: UIView {
    
    private let label = UILabel().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
        $0.textAlignment = .center
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for objective: Task) {
        self.label.text = objective.name
        self.layer.borderColor = objective.color.withAlphaComponent(0.8).cgColor
        self.backgroundColor = objective.color.withAlphaComponent(0.6)
    }
    
    private func setup() {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorCatalog.primaryColor.withAlphaComponent(0.8).cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = false
        self.backgroundColor = ColorCatalog.primaryColor.withAlphaComponent(0.4)
        
        addSubview(label)
        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: 60),
            heightAnchor.constraint(equalToConstant: 20),
            
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
}

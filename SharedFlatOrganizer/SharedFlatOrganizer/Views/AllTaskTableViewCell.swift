//
//  AllTaskTableViewCell.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 26.01.21.
//

import Foundation
import UIKit

class AllTaskTableViewCell: UITableViewCell {
    static let identifier: String = "AllTaskTableViewCell"
    
    let colorIndicator = UIView().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20/2
        $0.clipsToBounds = false
        $0.widthAnchor.constraint(equalToConstant: 20).activate()
        $0.heightAnchor.constraint(equalToConstant: 20).activate()
    })
    
    let taskLabel = UILabel().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
        $0.textAlignment = .left
    })
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for task: Task) {
        self.colorIndicator.backgroundColor = task.color
        self.taskLabel.text = task.name
    }
    
    private func setupUI() {
        [colorIndicator, taskLabel].forEach({ contentView.addSubview($0) })
        NSLayoutConstraint.activate([
            colorIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            colorIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            colorIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            taskLabel.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            taskLabel.centerYAnchor.constraint(equalTo: colorIndicator.centerYAnchor),
        ])
    }
    
}

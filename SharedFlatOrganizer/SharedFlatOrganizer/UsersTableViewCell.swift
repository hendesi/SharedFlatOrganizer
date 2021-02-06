//
//  UsersTableViewCell.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 25.01.21.
//

import Foundation
import UIKit

class UsersTableViewCell: UITableViewCell {
    static let identifier: String = "UsersTableViewCell"
    
    private let userImageView = UIImageView().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        
        $0.clipsToBounds = false
    })
    
    private let userNameLabel = UILabel().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
        $0.textAlignment = .left
    })
    
    private let stackView = UIStackView().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        $0.spacing = 4
    })
    private let objectiveTag = TaskTag().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for user: User) {
        userImageView.image = user.picture
        userNameLabel.text = user.name
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for objective in user.currentObjectives {
            let tag = TaskTag()
            tag.configure(for: objective)
            stackView.addArrangedSubview(tag)
        }
    }
    
    private func setupUI() {
        [userImageView, userNameLabel, stackView].forEach({ self.contentView.addSubview($0) })
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            userImageView.heightAnchor.constraint(equalToConstant: 25),
            userImageView.widthAnchor.constraint(equalToConstant: 25),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            stackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

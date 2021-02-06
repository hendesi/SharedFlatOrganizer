//
//  TaskTableViewCell.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 25.01.21.
//

import Foundation
import UIKit

class YourTaskTableViewCell: UITableViewCell {
    static let identifier: String = "TaskTableViewCell"
    
    private let uncheckedImageView = UIImageView().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "rectangle")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .gray
    })
    
    private let checkedImageView = UIImageView().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "checkmark.rectangle")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = ColorCatalog.primaryColor
        $0.isHidden = true
    })
    
    private let objectiveNameLabel = UILabel().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .darkGray
        $0.textAlignment = .left
    })
    
    private let objectiveTag = TaskTag().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    private var task: Task?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for task: Task) {
        objectiveNameLabel.text = task.name
        self.task = task
    }
    
    func markAsDone() {
        UIView.animate(withDuration: 0.3, animations: {
            self.uncheckedImageView.isHidden = !self.uncheckedImageView.isHidden
            self.checkedImageView.isHidden = !self.checkedImageView.isHidden
            self.objectiveNameLabel.textColor =
                self.objectiveNameLabel.textColor == ColorCatalog.primaryColor ? UIColor.gray : ColorCatalog.primaryColor
        })
        guard let task = task else { return }
        Storage.shared.finishedTasks.append(task)
    }
    
    private func setupUI() {
        [uncheckedImageView, checkedImageView, objectiveNameLabel].forEach({ self.contentView.addSubview($0) })
        NSLayoutConstraint.activate([
            uncheckedImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uncheckedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            uncheckedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            uncheckedImageView.heightAnchor.constraint(equalToConstant: 30),
            
            checkedImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            checkedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            checkedImageView.heightAnchor.constraint(equalToConstant: 30),
            
            objectiveNameLabel.leadingAnchor.constraint(equalTo: uncheckedImageView.trailingAnchor, constant: 16),
            objectiveNameLabel.centerYAnchor.constraint(equalTo: uncheckedImageView.centerYAnchor)
        ])
    }
}

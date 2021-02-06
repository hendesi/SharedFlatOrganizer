//
//  ViewController.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 22.01.21.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    let finishButton = Button().apply({
        $0.image = UIImage(systemName: "checkmark")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEnabled = true
        $0.title = "Finished Tasks"
    })
    
    let usersTableView = UITableView(frame: .zero, style: .plain).apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tag = 0
        $0.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
    })
    
    let myTasksTableView = UITableView(frame: .zero, style: .plain).apply({
        $0.tag = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.register(YourTaskTableViewCell.self, forCellReuseIdentifier: YourTaskTableViewCell.identifier)
    })
    
    let allTasksTableView = UITableView(frame: .zero, style: .plain).apply({
        $0.tag = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(AllTaskTableViewCell.self, forCellReuseIdentifier: AllTaskTableViewCell.identifier)
    })

    var clockViewController: UIHostingController<ClockView>?
    
    var observableAnglesWrapper: ObservableAnglesWrapper
    
    var users: [User] {
        guard let id = Storage.shared.user?.id else { fatalError("no user set in storage") }
        return overallUsers.filter({ $0.id != id }).sorted { $0.name < $1.name }
    }
    var overallUsers: [User] = []
    
    var tasks: [Task] = Storage.shared.tasks
    
    var myTasks: [Task] = Storage.shared.user?.currentObjectives ?? []
    
    init(_ observableAngles: [ObservableAngle]) {
        self.observableAnglesWrapper = ObservableAnglesWrapper(observableAngles)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    private func reloadTableViews() {
        self.usersTableView.reloadData()
        self.myTasksTableView.reloadData()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "🏠 Organizer", attributes:[
                                                    NSAttributedString.Key.foregroundColor: ColorCatalog.primaryColor,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.medium)]
                                                )
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupUI() {
        clockViewController = UIHostingController(rootView: ClockView(users: self.overallUsers, startingAngles: self.observableAnglesWrapper))
        guard let clockViewController = clockViewController else { return }
        clockViewController.view.translatesAutoresizingMaskIntoConstraints = false
        clockViewController.view.frame = self.view.bounds
        
        finishButton.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        finishButton.isEnabled = !Storage.shared.finishedTasks.isEmpty
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        myTasksTableView.delegate = self
        myTasksTableView.dataSource = self
        
        allTasksTableView.delegate = self
        allTasksTableView.dataSource = self
        
        self.view.backgroundColor = .white
        self.view.addSubview(clockViewController.view)
        self.view.addSubview(finishButton)
        self.view.addSubview(usersTableView)
        self.view.addSubview(myTasksTableView)
        self.view.addSubview(allTasksTableView)
        
        let usableWidth = (UIScreen.main.bounds.width - 32) / 2
        NSLayoutConstraint.activate([
            allTasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            allTasksTableView.leadingAnchor.constraint(equalTo: clockViewController.view.trailingAnchor, constant: 8),
            allTasksTableView.widthAnchor.constraint(equalToConstant: usableWidth),
            allTasksTableView.heightAnchor.constraint(equalToConstant: usableWidth),
            
            clockViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            clockViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            clockViewController.view.widthAnchor.constraint(equalToConstant: usableWidth),
            clockViewController.view.heightAnchor.constraint(equalToConstant: usableWidth),
            
            myTasksTableView.topAnchor.constraint(equalTo: clockViewController.view.bottomAnchor, constant: 24),
            myTasksTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTasksTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            myTasksTableView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            usersTableView.topAnchor.constraint(equalTo: myTasksTableView.bottomAnchor, constant: 16),
            usersTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usersTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            usersTableView.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -8),
            
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        self.addChild(clockViewController)
    }
    
    @objc func didTapFinishButton() {
        let user = Storage.shared.user
        UserAPI.updateUser(user, success: { users in
            guard let currentUserID = Storage.shared.user?.id,
                  let newCurrentUser = users.first(where: { $0.id == currentUserID })
            else { fatalError("failed to retrieve id of the current user") }
            Storage.shared.user = newCurrentUser
            Storage.shared.finishedTasks = []
            self.myTasks = Storage.shared.user?.currentObjectives ?? []
            self.overallUsers = users
            
            self.updateViews()
        }, failure: { error in
            
        })
    }
    
    private func updateViews() {
        self.observableAnglesWrapper.observableAngles = TaskAPI.getAngles(for: self.overallUsers)
        self.view.layoutSubviews()
        self.reloadTableViews()
        
        self.finishButton.isEnabled = !Storage.shared.finishedTasks.isEmpty
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return users.count
        case 1:
            return myTasks.count
        case 2:
            return tasks.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            return cellForUserTableView(tableView, cellForRowAt: indexPath)
        case 1:
            return cellForMyTaskTableView(tableView, cellForRowAt: indexPath)
        case 2:
            return cellForAllTaskTableView(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView.tag {
        case 0:
            return headerForUserTableView(tableView, viewForHeaderInSection: section)
        case 1:
            return headerForMyTaskTableView(tableView, viewForHeaderInSection: section)
        case 2:
            return headerForAllTaskTableView(tableView, viewForHeaderInSection: section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? YourTaskTableViewCell, tableView.tag == 1 else { return }
        cell.markAsDone()
        finishButton.isEnabled = !Storage.shared.finishedTasks.isEmpty
    }
}

//MARK: - TableView methods for UsersTableView
extension MainViewController {
    func cellForUserTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as? UsersTableViewCell
        else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(for: user)
        return cell
    }
    
    
    
    func headerForUserTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel().apply({
            $0.text = "🤝 Your Flatmates"
            $0.textColor = ColorCatalog.primaryColor
            $0.font = .systemFont(ofSize: 18, weight: .thin)
            $0.textAlignment = .center
            $0.backgroundColor = .white
        })
        return titleLabel
    }
    
    
    
}

//MARK: - TableView methods for MyTaskTableView
extension MainViewController {
    func cellForMyTaskTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YourTaskTableViewCell.identifier, for: indexPath) as? YourTaskTableViewCell
        else { return UITableViewCell() }
        let task = myTasks[indexPath.row]
        cell.configure(for: task)
        return cell
    }
    
    func headerForMyTaskTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let profileImageView = UIImageView().apply({
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = Storage.shared.user?.picture
            $0.layer.cornerRadius = 25/2
            $0.clipsToBounds = true
        })
        let titleLabel = UILabel().apply({
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "My Tasks"
            $0.textColor = ColorCatalog.primaryColor
            $0.font = .systemFont(ofSize: 25, weight: .thin)
            $0.textAlignment = .center
            $0.backgroundColor = .white
        })
        let view = UIView()
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 25),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
        
        return view
    }
}

//MARK: - TableView methods for AllTaskTableView
extension MainViewController {
    func cellForAllTaskTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTaskTableViewCell.identifier, for: indexPath) as? AllTaskTableViewCell
        else { return UITableViewCell() }
        let task = tasks[indexPath.row]
        cell.configure(for: task)
        return cell
    }
    
    func headerForAllTaskTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel().apply({
            $0.text = "🗂 All Tasks"
            $0.textColor = ColorCatalog.primaryColor
            $0.font = .systemFont(ofSize: 18, weight: .thin)
            $0.textAlignment = .center
            $0.backgroundColor = .white
        })
        return titleLabel
    }
}

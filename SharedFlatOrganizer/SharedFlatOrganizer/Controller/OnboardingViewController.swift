//
//  OnboardingViewController.swift
//  SharedFlatOrganizer
//
//  Created by Felix Desiderato on 25.01.21.
//

import Foundation
import UIKit
import SVProgressHUD

class OnboardingViewController: UIViewController {
    
    let profileView = UIButton().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 60
        $0.layer.borderWidth = 2
        $0.layer.borderColor = ColorCatalog.primaryColor.cgColor
        $0.setBackgroundImage(UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = ColorCatalog.primaryColor
    })
    
    let usernameTextField = TextField().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEnabled = true
        $0.superText = "Your name"
    })
    
    let submitButton = Button().apply({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "paperplane")
        $0.title = "Submit"
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "New Profile", attributes:[
                                                    NSAttributedString.Key.foregroundColor: ColorCatalog.primaryColor,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.medium)]
                                                )
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
    
    private func setupUI() {
        [profileView, usernameTextField].forEach({ view.addSubview($0) })
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 120),
            profileView.widthAnchor.constraint(equalTo: profileView.heightAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 32),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        submitButton.isEnabled = false
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        usernameTextField.clearButtonMode = .whileEditing
        usernameTextField.inputAccessoryView = submitButton
        usernameTextField.becomeFirstResponder()
        profileView.addTarget(self, action: #selector(didTapImageView), for: .touchUpInside)
    }
    
    @objc func didTapSubmitButton() {
        SVProgressHUD.show()
        let user = User(name: usernameTextField.text, pictureData: profileView.backgroundImage(for: .normal)?.jpeg(.lowest))
        UserAPI.createDemoData(with: user, completion: { users in
            let observableAngles = TaskAPI.getAngles(for: users)
            let mainVC = MainViewController(observableAngles)
            mainVC.overallUsers = users
            SVProgressHUD.dismiss()
            self.navigationController?.pushViewController(mainVC, animated: true)
        })
    }
    
    @objc func didTapImageView() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        submitButton.isEnabled = textField.hasText
    }
}

extension OnboardingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileView.setBackgroundImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

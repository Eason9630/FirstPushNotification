//
//  ViewController.swift
//  FirstPushNotification
//
//  Created by 林祔利 on 2023/9/10.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log in"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email Address"
        emailTextField.layer.borderWidth = 1
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passwordTextField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            label.isHidden = true
            emailTextField.isHidden = true
            passwordTextField.isHidden = true
            button.isHidden = true
            
            view.addSubview(signOutButton)
            signOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 52)
            signOutButton.addTarget(self, action: #selector(logOutTapButton), for: .touchUpInside)
        }
    }
    
    @objc private func logOutTapButton() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            label.isHidden = false
            emailTextField.isHidden = false
            passwordTextField.isHidden = false
            button.isHidden = false
            
            signOutButton.removeFromSuperview()
            
        }catch{
            print("An Error")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0,
                             y: 100,
                             width: view.frame.size.width,
                             height: 80)
        
        emailTextField.frame = CGRect(x: 20,
                                      y: label.frame.origin.y + label.frame.size.height + 10,
                                      width: view.frame.size.width - 40,
                                      height: 50)
       
        passwordTextField.frame = CGRect(x: 20,
                                         y: emailTextField.frame.origin.y + emailTextField.frame.size.height + 10,
                                         width: view.frame.size.width - 40,
                                         height: 50)
        
        button.frame = CGRect(x: 20,
                              y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 30,
                              width: view.frame.size.width - 40,
                              height: 52)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {        
            emailTextField.becomeFirstResponder()
        }
    }

    
    @objc private func didTapButton() {
        guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
            print("Missing Data")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let storngSelf = self else{
                return
            }
            guard error == nil else {
                // show account creation alert
                storngSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            print("You have Sign In")
            storngSelf.label.isHidden = true
            storngSelf.emailTextField.isHidden = true
            storngSelf.passwordTextField.isHidden = true
            storngSelf.button.isHidden = true
            
            storngSelf.emailTextField.resignFirstResponder()
            storngSelf.passwordTextField.resignFirstResponder()
        }
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let storngSelf = self else{
                    return
                }
                guard error == nil else {
                    // show account creation alert
                    print("Account created")
                    return
                }
                
                print("You have Sign In")
                storngSelf.label.isHidden = true
                storngSelf.emailTextField.isHidden = true
                storngSelf.passwordTextField.isHidden = true
                storngSelf.button.isHidden = true
                
                storngSelf.emailTextField.resignFirstResponder()
                storngSelf.passwordTextField.resignFirstResponder()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
}


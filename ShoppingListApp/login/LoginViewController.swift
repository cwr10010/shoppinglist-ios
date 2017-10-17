//
//  LoginViewController.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 11.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit
import os.log

class LoginViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authenticationDataSource = NetworkAuthenticationDataSource()
    
    let authorizationKeychain = AuthorizationKeychain()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - LoginViewController
    @IBAction func doLogin(_ sender: Any) {
        guard let username = usernameTextField.text else {
            self.createLoginFailureAlert()
            return
        }
        
        guard let password = passwordTextField.text else {
            self.createLoginFailureAlert()
            return
        }
        
        self.authenticationDataSource.doLogin(loginData: LoginData(username: username, password: password))
            .onFailure { error in
                debugPrint("Failed")
                self.createLoginFailureAlert(error: error)
            }.onSuccess { authData in
                self.authorizationKeychain.store(authData: authData)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                self.present(storyBoard.instantiateInitialViewController()!, animated: true, completion: nil)
            }
    }
    
    // MARK: - Private Methods
    private func createLoginFailureAlert(error: Error? = nil) {
        let alert = UIAlertController(title: "Login failed", message: "Login failed. Please check your credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}


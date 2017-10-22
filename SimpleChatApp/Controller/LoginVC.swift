//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confPasswordTxt: UITextField!
    @IBOutlet weak var signupLoginBtn: UIButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopActivitySpinner()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func setupLoginBtnPressed(_ sender: UIButton) {
        self.startActivitySpinner()
        if sender.titleLabel?.text == "Sign Up" {
            guard let username = usernameTxt.text, let password = passwordTxt.text, let confPassword = confPasswordTxt.text, usernameTxt.text != "", passwordTxt.text != "", confPasswordTxt.text != "" else {
                self.stopActivitySpinner()
                 self.view.endEditing(true)
                self.userDetailsErrorAlert()
                return
            }
            if password == confPassword {
                self.stopActivitySpinner()
                 self.view.endEditing(true)
                KeychainWrapper.standard.set(username, forKey: password)
                performSegue(withIdentifier: "toHome", sender: nil)
            } else {
                 self.view.endEditing(true)
                self.stopActivitySpinner()
                self.userDetailsErrorAlert()
            }
        } else {
            guard let username = usernameTxt.text, let password = passwordTxt.text, usernameTxt.text != "", passwordTxt.text != "" else {
                 self.view.endEditing(true)
                self.stopActivitySpinner()
                self.userNotExistErrorAlert()
                return
            }
            if username == KeychainWrapper.standard.string(forKey: password) {
                 self.view.endEditing(true)
                self.stopActivitySpinner()
                performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
    }

    func startActivitySpinner() {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
    }
    
    func stopActivitySpinner() {
        activitySpinner.isHidden = true
        activitySpinner.stopAnimating()
    }

    @IBAction func haveAccountBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Already Have Account? Log In" {
            confPasswordTxt.isHidden = true
            sender.setTitle("No account? Signup", for: .normal)
            signupLoginBtn.setTitle("Login", for: .normal)
        } else {
            confPasswordTxt.isHidden = false
            sender.setTitle("Already Have Account? Log In", for: .normal)
            signupLoginBtn.setTitle("Signup", for: .normal)
        }
    }
    
    func userDetailsErrorAlert() {
        let alert = UIAlertController.init(title: "Something Went Wrong", message: "Maybe passwords do not match.", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    func userNotExistErrorAlert() {
        let alert = UIAlertController.init(title: "Username/Password do not match", message: "Try Again", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
}


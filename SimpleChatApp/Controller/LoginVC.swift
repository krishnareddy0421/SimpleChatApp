//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
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
            guard let username = usernameTxt.text, let email = emailTxt.text, let password = passwordTxt.text, let confPassword = confPasswordTxt.text, usernameTxt.text != "", emailTxt.text != "", passwordTxt.text != "", confPasswordTxt.text != "" else {
                self.stopActivitySpinner()
                self.view.endEditing(true)
                self.userDetailsErrorAlert()
                return
            }
            if password == confPassword {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.userDetailsErrorAlert()
                        return
                    }
                    self.stopActivitySpinner()
                    self.view.endEditing(true)
                    guard let userId = user?.uid else {
                        self.userDetailsErrorAlert()
                        return
                    }
                    DatabaseService.instance.saveUserData(userID: userId, userName: username, userEmail: email, userPassword: password, completion: { (success) in
                        if success {
                            self.performSegue(withIdentifier: "toHome", sender: nil)
                        } else {
                            self.userDetailsErrorAlert()
                        }
                    })
                })
            } else {
                self.view.endEditing(true)
                self.stopActivitySpinner()
                self.userDetailsErrorAlert()
            }
        } else {
            guard let email = emailTxt.text, let password = passwordTxt.text, usernameTxt.text != "", passwordTxt.text != "" else {
                 self.view.endEditing(true)
                self.stopActivitySpinner()
                self.userNotExistErrorAlert()
                return
            }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    self.userDetailsErrorAlert()
                    return
                }
                self.view.endEditing(true)
                self.stopActivitySpinner()
                self.performSegue(withIdentifier: "toHome", sender: nil)
            })
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
            usernameTxt.isHidden = true
            confPasswordTxt.isHidden = true
            sender.setTitle("No account? Signup", for: .normal)
            signupLoginBtn.setTitle("Login", for: .normal)
        } else {
            usernameTxt.isHidden = false
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


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
    
    @IBAction func signUpLoginBtnPressed(_ sender: UIButton) {
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
                        self.stopActivitySpinner()
                        self.userEmailAlreadyExistsErrorAlert()
                        return
                    }
                    self.stopActivitySpinner()
                    self.view.endEditing(true)
                    guard let uid = user?.uid else {
                        self.stopActivitySpinner()
                        self.userDetailsErrorAlert()
                        return
                    }
                    DatabaseService.instance.userID = uid
                    DatabaseService.instance.saveUserData(userID: uid, userName: username, userEmail: email, completion: { (success) in
                        if success {
                            UserDataService.instance.setUserData(userId: uid, userName: username, userEmail: email)
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
            guard let email = emailTxt.text, let password = passwordTxt.text, emailTxt.text != "", passwordTxt.text != "" else {
                 self.view.endEditing(true)
                self.stopActivitySpinner()
                self.userNotExistErrorAlert()
                return
            }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    self.stopActivitySpinner()
                    self.userDetailsErrorAlert()
                    return
                }
                guard let id = user?.uid else {
                    return
                }
                DatabaseService.instance.userID = id
                DatabaseService.instance.getUserData(userID: id, completion: { (success) in
                    if success {
                        self.view.endEditing(true)
                        self.stopActivitySpinner()
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                    } else {
                        self.somethingWentWrong()
                    }
                })
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.usernameTxt.text = ""
        self.emailTxt.text = ""
        self.passwordTxt.text = ""
        self.confPasswordTxt.text = ""
    }
}


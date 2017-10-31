//
//  Alerts.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/31/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func somethingWentWrong() {
        let alert = UIAlertController.init(title: "Something Went Wrong", message: "Try Again", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
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
    
    func userEmailAlreadyExistsErrorAlert() {
        let alert = UIAlertController.init(title: "Account with this email already exists.", message: "Try with other email", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
}

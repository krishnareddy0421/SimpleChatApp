//
//  ChatVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/28/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let friendDetails = DatabaseService.instance.friendDetails
    var time: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        self.title = friendDetails["username"] as? String
        txtField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }

    @objc func textDidChange(textField: UITextField) {
        sendButton.alpha = 1
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        guard let msgText = txtField.text, txtField.text != "" else {
            return
        }
        time = getCurrentTime()
        DatabaseService.instance.sendMessage(message: msgText, sendTime: time!) { (success) in
            if success {
                print(success)
            } else {
                // error handling
            }
        }
    }
    
    func getCurrentTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        let dateString = formatter.string(from: Date())
        
        return dateString
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

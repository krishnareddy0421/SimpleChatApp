//
//  ChatVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/28/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let friendDetails = DatabaseService.instance.friendDetails
    var time: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        self.title = friendDetails["username"] as? String
        txtField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
        self.getAllMessagesByFriend()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getAllMessagesByFriend() {
        let userUid = DatabaseService.instance.userID!
        let friendUid = DatabaseService.instance.friendDetails["userId"] as? String
        let bothUid = "\(userUid)+\(friendUid!)"
        DatabaseService.instance.getAllMessages(uid: bothUid) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    @objc func textDidChange(textField: UITextField) {
        sendButton.alpha = 1
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        guard let msgText = txtField.text, txtField.text != "" else {
            return
        }
        time = getCurrentTime()
        DatabaseService.instance.sendMessageToUserDatabase(message: msgText, sendTime: time!) { (success) in
            if success {
                DatabaseService.instance.sendMessageToFriendDatabase(message: msgText, sendTime: self.time!) { (success) in
                    if success {
                        self.txtField.text = ""
                        self.view.endEditing(true)
                    }
                }
            } else {
                self.somethingWentWrong()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = DatabaseService.instance.messages[indexPath.row]
        if message["senderUid"] as? String == DatabaseService.instance.userID {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "userMsgCell", for: indexPath) as? UserMessageCell {
                
                cell.messageLbl.text = message["message"] as? String
                cell.timeLbl.text = message["time"] as? String
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "friendMsgCell", for: indexPath) as? UserMessageCell {
                
                cell.messageLbl.text = message["message"] as? String
                cell.timeLbl.text = message["time"] as? String
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

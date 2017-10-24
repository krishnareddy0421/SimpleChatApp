//
//  SearchPeopleCell.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/23/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class SearchPeopleCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addRequestBtn: UIButton!
    
    var userArray :NSDictionary?
    
    @IBAction func addFriendBtn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add Friend" {
            DatabaseService.instance.requestSent(userUid: DatabaseService.instance.userUID, friendUid: userArray!["id"]! as! String) { (success) in
                if success {
                    sender.setTitle("Request Sent", for: .normal)
                } else {
                    // error handling
                }
            }
        } else {
            // remove from database
        }
    }
}

//
//  RecentChatsVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/26/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecentChatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getContacts()
    }
    
    func getContacts() {
        DatabaseService.instance.getAllRecentContacts(userUid: DatabaseService.instance.userID!) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseService.instance.recentContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchPeopleCell", for: indexPath) as? RecentChatCell {
            let user = DatabaseService.instance.recentContacts[indexPath.row]
            cell.nameLbl.text = "\(String(describing: user["username"]!))"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        DatabaseService.instance.friendDetails = DatabaseService.instance.recentContacts[indexPath.row]
        self.presentChatVC()
    }
    
    
    func presentChatVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatVCNavigator")
        self.present(controller, animated: true, completion: nil)
    }
}

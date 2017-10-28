//
//  PeopleVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/23/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class PeopleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getUsers()
    }
    
    func getUsers() {
        DatabaseService.instance.getAllUsers { (success) in
            if success {
                self.tableView.reloadData()
            } else {
                // error handling
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseService.instance.allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? PeopleCell {
            let user = DatabaseService.instance.allUsers[indexPath.row]
            cell.usernameLbl.text = "\(String(describing: user["username"]!))"
            cell.useremailLbl.text = "\(String(describing: user["useremail"]!))"
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

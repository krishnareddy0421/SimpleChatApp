//
//  PeopleVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/23/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PeopleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var friendsArray = [NSDictionary?]()
    
    let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ref.child("chatApp").child("friends").child(DatabaseService.instance.userUID).queryOrdered(byChild: "status").observe(.childAdded, with: { (snapshot) in
            self.friendsArray.append(snapshot.value as? NSDictionary)
            self.tableView.reloadData()
        }) { (error) in
            // error handling
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? PeopleCell {
            let user: NSDictionary?
            user = friendsArray[indexPath.row]
            
            cell.nameLbl.text = user?["friendUid"] as? String
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func getUserByUid(uid: String) {
        
    }
}

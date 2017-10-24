//
//  SearchResultsVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/23/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    
    let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for people"
        tableView.tableHeaderView = searchController.searchBar
        
        ref.child("chatApp").child("users").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            self.usersArray.append(snapshot.value as? NSDictionary)
        }) { (error) in
            // error handling
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredContent(searchText: self.searchController.searchBar.text!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return self.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchPeopleCell", for: indexPath) as? SearchPeopleCell {
            
            let user: NSDictionary?
            if searchController.isActive && searchController.searchBar.text != "" {
                user = filteredUsers[indexPath.row]
            } else {
                user = self.filteredUsers[indexPath.row]
            }
            
            cell.nameLbl.text = user?["name"] as? String
            cell.userArray = user!
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func filteredContent(searchText: String) {
        self.filteredUsers = self.usersArray.filter{ user in
            let username = user!["name"] as? String
            return (username?.lowercased().contains(searchText.lowercased()))!
        }
        self.tableView.reloadData()
    }
}

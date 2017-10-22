//
//  HomeVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate  {

    // MARK: - Outlets
    @IBOutlet weak var customSegmentCntrl: TwicketSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sectionTitles = ["Chats", "People", "Search"]
        customSegmentCntrl.setSegmentItems(sectionTitles)
        
        tableView.delegate = self
        tableView.dataSource = self
        customSegmentCntrl.delegate = self
    }

    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            print("Chats")
        case 1:
            print("People")
        case 2:
            print("Search")
        default:
            print("Chats")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as? PeopleCell {
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

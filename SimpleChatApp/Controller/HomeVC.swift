//
//  HomeVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController, TwicketSegmentedControlDelegate  {

    // MARK: - Outlets
    @IBOutlet weak var customSegmentCntrl: TwicketSegmentedControl!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    
    // MARK: - Container View Outlets
    @IBOutlet weak var recentChatsContainerView: UIView!
    @IBOutlet weak var peopleContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserDataService.instance.username
        let sectionTitles = ["Chats", "People"]
        customSegmentCntrl.setSegmentItems(sectionTitles)
        self.sectionTitleLbl.text = "Recent Chats"
        customSegmentCntrl.delegate = self
        self.recentChatsContainerView.isHidden = true
        self.peopleContainerView.isHidden = true
    }

    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            self.sectionTitleLbl.text = "Recent Chats"
            self.recentChatsContainerView.isHidden = false
            self.peopleContainerView.isHidden = true
        case 1:
            self.sectionTitleLbl.text = "People"
            self.recentChatsContainerView.isHidden = true
            self.peopleContainerView.isHidden = false
        default:
            self.sectionTitleLbl.text = "Recent Chats"
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDataService.instance.userLogout()
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            // error handling
            print(error)
        }
    }
}

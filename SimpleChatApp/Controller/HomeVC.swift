//
//  HomeVC.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, TwicketSegmentedControlDelegate  {

    // MARK: - Outlets
    @IBOutlet weak var customSegmentCntrl: TwicketSegmentedControl!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    
    // MARK: - Container View Outlets
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var peopleContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sectionTitles = ["Chats", "People", "Search"]
        customSegmentCntrl.setSegmentItems(sectionTitles)
        self.sectionTitleLbl.text = "Recent Chats"
        customSegmentCntrl.delegate = self
        self.searchContainerView.isHidden = true
        self.peopleContainerView.isHidden = true
    }

    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            self.sectionTitleLbl.text = "Recent Chats"
            self.peopleContainerView.isHidden = true
            self.searchContainerView.isHidden = true
        case 1:
            self.sectionTitleLbl.text = "People"
            self.peopleContainerView.isHidden = false
            self.searchContainerView.isHidden = true
        case 2:
            self.sectionTitleLbl.text = "Search for people"
            self.peopleContainerView.isHidden = true
            self.searchContainerView.isHidden = false
        default:
            self.sectionTitleLbl.text = "Recent Chats"
        }
    }
}

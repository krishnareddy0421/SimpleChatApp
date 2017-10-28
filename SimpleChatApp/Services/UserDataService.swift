//
//  UserDataService.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/26/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var username = ""
    public private(set) var useremail = ""
    
    func setUserData(userId: String, userName: String, userEmail: String) {
        self.id = userId
        self.username = userName
        self.useremail = userEmail
    }
    
    func userLogout() {
        self.id = ""
        self.username = ""
        self.useremail = ""
    }
}

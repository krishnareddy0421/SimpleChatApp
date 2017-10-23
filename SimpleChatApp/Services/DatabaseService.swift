//
//  DatabaseService.swift
//  SimpleChatApp
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias CompletionHandler = (_ Sucess: Bool) -> ()

class DatabaseService {
    static let instance = DatabaseService()
    
    func saveUserData(userID: String, userName: String, userEmail: String, userPassword: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let userReference = ref.child("users").child(userID)
        let values = ["id": userID, "name": userName, "email": userEmail, "password": userPassword]
        userReference.updateChildValues(values, withCompletionBlock: { (databaseErr, ref) in
            if databaseErr != nil {
                completion(false)
                return
            }
            completion(true)
        })
    }
}

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
    
    func saveUserData(userID: String, userName: String, userEmail: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let userReference = ref.child("chatApp").child("users").child(userID)
        let values = ["id": userID, "name": userName, "email": userEmail]
        userReference.updateChildValues(values, withCompletionBlock: { (databaseErr, ref) in
            if databaseErr != nil {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func getUserData(userID: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let userReference = ref.child("chatApp").child("users").child(userID)
        userReference.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let name = dictionary["name"] as? String else { return }
                guard let email = dictionary["email"] as? String else { return }
                guard let id = dictionary["id"] as? String else { return }
                
                UserDataService.instance.setUserData(userId: id, userName: name, userEmail: email)
                completion(true)
            }
        }, withCancel: nil)
    }
}

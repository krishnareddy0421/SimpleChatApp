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
    
    var userUID: String!
    
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
    
    func requestSent(userUid: String, friendUid: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let userReference = ref.child("chatApp").child("friends").child(friendUid).childByAutoId()
        let values = ["friendUid": userUid, "status": "request"]
        userReference.updateChildValues(values, withCompletionBlock: { (databaseErr, ref) in
            if databaseErr != nil {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func getAllRequest(userUid: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        ref.child("chatApp").child("friends").child(userUid).queryOrdered(byChild: "status").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            completion(true)
        })
    }
}

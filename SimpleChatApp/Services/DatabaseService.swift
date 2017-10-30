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
    
    var userID: String?
    var friendDetails = [String: Any]()
    var allUsers = [[String: Any]]()
    var messages = [[String: Any]]()
    
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
            if let user = snapshot.value as? [String: AnyObject] {
                guard let name = user["name"] as? String else {
                    completion(false)
                    return
                }
                guard let email = user["email"] as? String else {
                    completion(false)
                    return
                }
                guard let id = user["id"] as? String else {
                    completion(false)
                    return
                }
                
                UserDataService.instance.setUserData(userId: id, userName: name, userEmail: email)
                completion(true)
            } else {
                completion(false)
            }
        }, withCancel: nil)
    }
    
    func getAllUsers(completion: @escaping CompletionHandler) {
        self.allUsers.removeAll()
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let userReference = ref.child("chatApp").child("users")
        userReference.observe(.childAdded, with: { (snapshot) in
            if let user = snapshot.value as? [String: Any] {
                if user["id"] as? String != self.userID {
                    guard let name = user["name"] as? String else {
                        completion(false)
                        return
                    }
                    guard let email = user["email"] as? String else {
                        completion(false)
                        return
                    }
                    guard let id = user["id"] as? String else {
                        completion(false)
                        return
                    }
                    
                    let values = ["userId": id, "username": name, "useremail": email]
                    self.allUsers.append(values)
                }
            }
            completion(true)
        }, withCancel: nil)
    }
    
    func sendMessageToUserDatabase(message: String, sendTime: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let uidRef = "\(userID!)+\(friendDetails["userId"]!)"
        let userReference = ref.child("chatApp").child("chats").child(uidRef).childByAutoId()
        let values = ["senderUid": userID, "message": message, "time": sendTime]
        userReference.updateChildValues(values, withCompletionBlock: { (databaseErr, ref) in
            if databaseErr != nil {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func sendMessageToFriendDatabase(message: String, sendTime: String, completion: @escaping CompletionHandler) {
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let uidRef = "\(friendDetails["userId"]!)+\(userID!)"
        let userReference = ref.child("chatApp").child("chats").child(uidRef).childByAutoId()
        let values = ["senderUid": userID, "message": message, "time": sendTime]
        userReference.updateChildValues(values, withCompletionBlock: { (databaseErr, ref) in
            if databaseErr != nil {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func getAllMessages(uid: String, completion: @escaping CompletionHandler) {
        self.messages.removeAll()
        let ref = Database.database().reference(fromURL: "https://simplechatapp-ab260.firebaseio.com/")
        let userReference = ref.child("chatApp").child("chats").child(uid)
        userReference.observe(.childAdded, with: { (snapshot) in
            if let message = snapshot.value as? [String: Any] {
                guard let msg = message["message"] as? String else {
                    completion(false)
                    return
                }
                guard let uid = message["senderUid"] as? String else {
                    completion(false)
                    return
                }
                guard let sendTime = message["time"] as? String else {
                    completion(false)
                    return
                }
                
                let values = ["senderUid": uid, "message": msg, "time": sendTime]
                self.messages.append(values)
            }
            completion(true)
        }, withCancel: nil)
    }
}

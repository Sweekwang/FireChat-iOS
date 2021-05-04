//
//  Message.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 23/4/21.
//

import Firebase
import FirebaseFirestore

struct Message {
    let text: String
    let toID: String
    let fromID: String
    var timestamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toID : fromID
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toId"] as? String ?? ""
        self.fromID = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        
        self.isFromCurrentUser = fromID == Auth.auth().currentUser!.uid
    }
}

struct Conversation{
    let user: User
    let message: Message
}

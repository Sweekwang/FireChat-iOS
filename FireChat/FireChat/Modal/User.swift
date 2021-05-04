//
//  User.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 13/4/21.
//

import Foundation

struct User {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
    var token: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.token = dictionary["token"] as? String ?? ""
    }
    
    func getUserDict() -> [String: String] {
        let dictionary = ["uid": uid,
                          "profileImageUrl": profileImageUrl,
                          "username": username,
                          "fullname": fullname,
                          "email": email]
        
        return dictionary
        
    }
}

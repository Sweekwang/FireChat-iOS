//
//  MessageViewModal.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 23/4/21.
//

import UIKit

struct MessageViewModal {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        print("DEBUG 2: \(message.isFromCurrentUser)")
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool{
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil}
        return URL(string: user.profileImageUrl)
    }
    
    init(message: Message) {
        self.message = message
    }
    
}

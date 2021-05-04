//
//  ConversationViewModel.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 26/4/21.
//

import Foundation

struct ConversationViewModel {
    private let converstation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: converstation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = converstation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(converstation: Conversation) {
        self.converstation = converstation
    }
}

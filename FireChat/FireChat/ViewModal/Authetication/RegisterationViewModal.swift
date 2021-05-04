//
//  RegisterationViewModal.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 9/4/21.
//

import Foundation

struct RegisterationViewModal:AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
    }
    
}

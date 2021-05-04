//
//  AccountInforViewModel.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 4/5/21.
//

import Foundation

enum AccountInforViewModel: Int, CaseIterable  {
    case account
    case personnelInformation
    
    var sectionValues: [String] {
        switch self {
        case .account:
            return ["username", "email"]
        case .personnelInformation:
            return ["fullname"]
        }
    }
    
    var sectionName: String {
        switch self {
        case .account:
            return "Account Information"
        case .personnelInformation:
            return "Personnel Information"
        }
    }
}

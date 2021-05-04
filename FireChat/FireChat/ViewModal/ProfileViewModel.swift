//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 28/4/21.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable  {
    case accountInfo
    
    var decription: String {
        switch self {
        case .accountInfo: return "Account Info"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        }
    }
}

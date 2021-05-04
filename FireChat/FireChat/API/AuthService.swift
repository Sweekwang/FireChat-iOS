//
//  AuthService.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 10/4/21.
//

import Firebase
import FirebaseFirestore
import UIKit

struct RegistrationCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?){
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion!(error)
                    }

                    guard let uid = result?.user.uid else { return }
                    
                    let data: [String: Any] = ["email": credentials.email,
                                               "fullname": credentials.fullname,
                                               "profileImageUrl": profileImageUrl,
                                               "uid": uid,
                                               "username": credentials.username]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                    
                }
            }
        }
    }
    
    func updateUserData(user: User, completion: ((Error?) -> Void)?) {
        let data: [String: Any] = ["email": user.email,
                                   "fullname": user.fullname,
                                   "profileImageUrl": user.profileImageUrl,
                                   "uid": user.uid,
                                   "username": user.username,
                                   "token": user.token]
        
        Firestore.firestore().collection("users").document(user.uid).setData(data, completion: completion)
    }
}

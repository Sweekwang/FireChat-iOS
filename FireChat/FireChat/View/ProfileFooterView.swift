//
//  ProfileFooterView.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 28/4/21.
//

import UIKit
protocol ProfileFooterDelegate: AnyObject {
    func handleLogout()
}
class ProfileFooterView: UIView {
    // MARK: - Properties
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor,
                            paddingLeft: 28, paddingRight: 28)
        logoutButton.setHeight(height: 50)
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
}


//
//  ProfileHeader.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 27/4/21.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func dismissController()
}

class ProfileHeader: UIView {
    // MARK: - Properties
    var user: User? {
        didSet { poplateUserData() }
    }
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Great Day"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Text"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: - Selector
    @objc func handleDismissal(){
        print("DEBUG: Called 1")
        delegate?.dismissController()
    }
    
    // MARK: - Helpers
    func poplateUserData() {
        guard let user = user else {return}
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
    
    func configureUI() {
        configureGradientLayer()
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
    func configureGradientLayer(){
        backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1).cgColor, UIColor.init(red: 42/255, green: 65/255, blue: 112/255, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}


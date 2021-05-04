//
//  ConversationController.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 5/4/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationsController: UIViewController{
    
    // MARK: - Properties
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
//    private let newMessageButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "plus"), for: .normal)
//        button.backgroundColor = .systemPurple
//        button.tintColor = .white
//        button.imageView?.setDimensions(height: 24, width: 24)
//        button.layer.cornerRadius = 56/2
//        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
//        return button
//    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        fetchConversations()
        updateToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    func updateToken(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            var user = user
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    user.token = token
                    
                    AuthService.shared.updateUserData(user: user, completion: nil)
                    
                    
                }
            }
            
        }
    }
    
    // MARK: - Selectors
    @objc func showNewMessage(){
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showProfile(){
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
    
    // MARK: - API:
    func fetchConversations() {
        showLoader(true)
        
        Service.fetchConverstations { conversations in
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.showLoader(false)
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
        
        showLoader(false)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in. Present login screen here...")
            presentLoginScreen()
        } else {
            print("DEBUG: User is logged in. Configure controller...")
        }
        
    }
    
    func loggout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("[ConversationController]DEBUG: Error Signing out ....")
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        // Code that require to change the UI will go here.
        view.backgroundColor = .white
        
        configureTableView()
        
        
        let image = UIImage(systemName: "person.circle")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        let plusButton = UIButton()
        plusButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        plusButton.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
            
//        view.addSubview(newMessageButton)
//        newMessageButton.setDimensions(height: 56, width: 56)
//        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConverstationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func showChatController(forUser user: User){
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
    
}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConverstationCell
        cell.converstation = conversations[indexPath.row]
        
        return cell
    }
    
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        tableView.deselectRow(at: indexPath, animated: true)
        showChatController(forUser: user)
    }
}

extension ConversationsController: NewMessageControllerDelegate{
    func controller(_ controller: NewMessageController, wantsToStartCHatWith user: User) {
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
}

// MARK: - ProfileControllerDelegate
extension ConversationsController: ProfileControllerDelegate{
    func handleLogout() {
        loggout()
    }
}

extension ConversationsController: AuthenticationDelegate{
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchConversations()
    }
}

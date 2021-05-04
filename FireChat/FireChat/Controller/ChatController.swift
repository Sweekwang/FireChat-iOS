//
//  ChatController.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 14/4/21.
//

import UIKit

class ChatController: UICollectionViewController {
    // MARK: - Properties
    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    // MARK: - Lifecycle
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func keyboardWillShow() {
        self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                         at: .top,
                                         animated: false)
    }
    
    @objc func keyboardDidShow() {
        self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                         at: .bottom,
                                         animated: false)
    }
    
    // MARK: - API
    
    func fetchMessages() {
        showLoader(true)
        Service.fetchMessage(forUser: user) { (messages) in
            self.showLoader(false)
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                             at: .bottom,
                                             animated: true)
            print(messages)
        }
        self.showLoader(false)
    }
    
    // MARK: - Helpers
    func configureUI(){
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = _flowLayout
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}
extension ChatController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

extension ChatController: CustomInputAsscessoryViewDelegate{
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        Service.uploadMessage(message, to: user) { error in
            if let error = error {
                print("DEBUG: Failed to upload message with error \(error.localizedDescription)")
                return
            }
            let token = self.user.token
            
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: token, title: self.user.username, body: message)
            
            
            inputView.clearMessageText()
        }
    }
}

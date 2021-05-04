//
//  ProfileController.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 27/4/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "profileCell"

protocol ProfileControllerDelegate: AnyObject {
    func handleLogout()
}
class ProfileController: UITableViewController {
    
    // MARK: - Properties
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0,
                                                             y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    weak var delegate: ProfileControllerDelegate?
    
    private var footerView = ProfileFooterView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    // MARK: - Selectors
    
    // MARK: - API
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        showLoader(true)
        
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.showLoader(false)
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
    }
    
    func showAccController(){
        let controller = AccountInfoViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProfileController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModal = viewModel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        switch viewModel {
        case .accountInfo:
            showAccController()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Adding a empty section header. This is different from tableview header.
        
        return UIView()
    }
}

// MARK: ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate{
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileController: ProfileFooterDelegate{
    func handleLogout() {
        let alert = UIAlertController(title: "nil", message: "Are you sure you want to logout", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

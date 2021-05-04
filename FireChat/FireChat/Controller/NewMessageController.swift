//
//  NewMessageController.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 12/4/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol  NewMessageControllerDelegate: AnyObject {
    // NOTE: - Class-Only Protocols
    //       - Why pass the controller? Because in case we need to do anything with it.
    func controller(_ controller: NewMessageController, wantsToStartCHatWith user: User)
}

class NewMessageController: UITableViewController{
    
    // MARK: - Properties
    private var users = [User]()
    private var filterUser = [User]()
    weak var delegate: NewMessageControllerDelegate? // weak to prevent retain lifecycle
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    // MARK: - API
    func fetchUsers() {
        showLoader(true)
        
        Service.fetchUsers { (users) in
            self.showLoader(false)
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Selector
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MAERK: - Helpers
    func configureUI(){
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self // This is a protocol to detect changes.
        
        searchController.searchBar.showsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false // This will not give a dark background when clicked.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        navigationItem.searchController = searchController
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
    
}


// MARK: - UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filterUser[indexPath.row] : users[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegates

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterUser[indexPath.row] : users[indexPath.row]
        print("DEBUG: Selected user is \(user.username)")
        delegate?.controller(self, wantsToStartCHatWith: user)
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUser = users.filter({ (user) -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        self.tableView.reloadData()
        print("DEBUG: \(filterUser)")
    }
}

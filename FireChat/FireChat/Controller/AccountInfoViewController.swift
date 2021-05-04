//
//  AccountInfoViewController.swift
//  FireChat
//
//  Created by Swee Kwang Chua on 1/5/21.
//

import UIKit
import Firebase

class AccountInfoViewController: UIViewController {
    private var user: User? {
        didSet{
            tableview.reloadData()
        }
    }
    
    private let tableview: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.rowHeight = 64
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        
    }
    
    // MARK: - API
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        showLoader(true)
        
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.showLoader(false)
        }
    }
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        setupNavbar()
        tableview.dataSource = self
        
        view.addSubview(tableview)
        tableview.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func setupNavbar() {
        configureNavigationBar(withTitle: "Account Info", prefersLargeTitles: true)

        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.setTitle("Back", for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

}

extension AccountInfoViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return (user != nil ? AccountInforViewModel.allCases.count : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (user != nil ? AccountInforViewModel.init(rawValue: section)!.sectionValues.count : 0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AccountInforViewModel.init(rawValue: section)?.sectionName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let section = indexPath.section
        let row = indexPath.row
        let titleText = AccountInforViewModel.init(rawValue: section)!.sectionValues[row]
        let titleString = NSMutableAttributedString(string: titleText.capitalized + ": ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        let valueString = NSMutableAttributedString(string: (user?.getUserDict()[titleText])!)
        titleString.append(valueString)
        
        cell.textLabel?.attributedText = titleString
        return cell
    }
    
}

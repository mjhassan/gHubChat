//
//  ViewController.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class InitialController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let segue_id = "MessageViewControllerSegue"
    private var loading: Bool = false {
        didSet {
            loading ? showSpinner(onView: self.view):hideSpinner()
        }
    }
    
    private var filtering: Bool = false
    
    private lazy var searchBar: UISearchBar = {
        let searchBar:UISearchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = AppDelegate.background
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        
        let textField = searchBar.childView(of: UITextField.self)
        textField?.enablesReturnKeyAutomatically = false
        
        return searchBar
    }()
    
    private lazy var viewModel: InitialViewModelProtocol = {
        let viewModel = InitialViewModel(bind: self)
        
        return viewModel
    }()
    
    private lazy var titleView: UIBarButtonItem = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.text = "gHubChat"
        label.textColor = .white
        
        return UIBarButtonItem(customView: label)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segue_id,
            let destination = segue.destination as? MessageViewController {
            destination.viewModel = MessageViewModel(buddy: sender as! User)
        }
    }
}

private extension InitialController {
    func configureView() {
        navigationItem.leftBarButtonItem = titleView
        
        tableView.backgroundView = UIImageView(image: AppDelegate.background)
        tableView.tableHeaderView = searchBar
        tableView.tableFooterView = UIView()
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.bounds.height), animated: false)
    }
}

extension InitialController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        cell.user = viewModel.user(at: indexPath.item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = viewModel.user(at: indexPath.item)
        performSegue(withIdentifier: segue_id, sender: user)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard filtering == false else { return }
        
        if indexPath.row == (viewModel.userCount - 1) {
            let paggingStart = viewModel.lastUserId
            viewModel.loadData(paggingStart)
        }
    }
}

extension InitialController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filtering = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filtering = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.filter = textSearched.replacingOccurrences(of: "@", with: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension InitialController: InitialViewDelegate {
    func didUpdatedData() {
        loading = false
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func willStartNetworkActivity() {
        loading = true
    }
    
    func didFailedWithError(_ error: Error?) {
        loading = false
        
        let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription ?? "An unknown error occurred", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async { [unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
}

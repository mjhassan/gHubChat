//
//  ViewController.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InitialController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let segue_id = "MessageViewControllerSegue"
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
    
    private lazy var viewModel: InitialViewModel = {
        let viewModel = InitialViewModel()
        
        return viewModel
    }()
    
    private lazy var titleView: UIBarButtonItem = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.text = "gHubChat"
        label.textColor = .white
        
        return UIBarButtonItem(customView: label)
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK:- system functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViews()
        
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
    
    func bindViews() {
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
            guard let _ws = self else { return }
            
            loading ? _ws.showSpinner(onView: _ws.view):_ws.hideSpinner()
        })
        .disposed(by: disposeBag)
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: UserCell.identifier)) {
                index, user, cell in
                
                guard let userCell = cell as? UserCell else { return }
                userCell.user = user
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            guard let user = self?.viewModel.user(at: indexPath.item),
                let seugeId = self?.segue_id else { return }
            
            self?.performSegue(withIdentifier: seugeId, sender: user)
        })
        .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.subscribe(onNext: { [weak self] cell, indexPath in
            
            guard self?.filtering == false,
                let userCount = self?.viewModel.userCount,
                let paggingStart = self?.viewModel.lastUserId else {
                    return
            }
            
            if indexPath.row == (userCount - 1) {
                self?.viewModel.loadData(paggingStart)
            }
        })
        .disposed(by: disposeBag)
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

//extension InitialController: InitialViewDelegate {
//    func didUpdatedData() {
//        loading = false
//
//        DispatchQueue.main.async { [unowned self] in
//            self.tableView.reloadData()
//        }
//    }
//
//    func willStartNetworkActivity() {
//        loading = true
//    }
//
//    func didFailedWithError(_ error: Error?) {
//        loading = false
//
//        let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription ?? "An unknown error occurred", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        DispatchQueue.main.async { [unowned self] in
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//}

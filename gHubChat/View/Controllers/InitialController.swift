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
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        
        let textField = searchBar.childView(of: UITextField.self)
        textField?.enablesReturnKeyAutomatically = false
        
        return searchBar
    }()
    
    private lazy var titleView: UIBarButtonItem = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.text = "gHubChat"
        label.textColor = .white
        
        return UIBarButtonItem(customView: label)
    }()
    
    private lazy var viewModel: InitialViewModelProtocol = {
        let viewModel = InitialViewModel(service: Services())
        
        return viewModel
    }()
    
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
            .disposed(by: viewModel.disposeBag)
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: UserCell.identifier)) {
                _, user, cell in
                guard let userCell = cell as? UserCell else { return }
                userCell.user = user
        }
        .disposed(by: viewModel.disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                guard let user = self?.viewModel.user(at: indexPath.item),
                    let seugeId = self?.segue_id else { return }
                
                self?.performSegue(withIdentifier: seugeId, sender: user)
            })
            .disposed(by: viewModel.disposeBag)
        
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard self?.filtering == false,
                    let userCount = self?.viewModel.userCount,
                    let paggingStart = self?.viewModel.lastUserId else {
                        return
                }
                
                if indexPath.row == (userCount - 1) {
                    self?.viewModel.loadData(paggingStart)
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        tableView.rx
            .contentOffset
            .changed
            .subscribe(onNext: { [weak self] point in
                if self?.searchBar.isFirstResponder == true && self?.searchBar.text?.isEmpty == true {
                    self?.searchBar.resignFirstResponder()
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        searchBar.rx
            .textDidBeginEditing
            .subscribe { [weak self] event in
                self?.filtering = true
        }
        .disposed(by: viewModel.disposeBag)
        
        searchBar.rx
            .textDidEndEditing
            .subscribe { [weak self] event in
                self?.filtering = false
        }
        .disposed(by: viewModel.disposeBag)
        
        searchBar.rx
            .text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0.replacingOccurrences(of: "@", with: "") }
            .bind(to: viewModel.query)
            .disposed(by: viewModel.disposeBag)
        
        searchBar.rx
            .searchButtonClicked
            .subscribe { [weak self] clicked in
                self?.searchBar.resignFirstResponder()
        }
        .disposed(by: viewModel.disposeBag)
    }
}

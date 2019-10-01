//
//  MessageViewController.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MessageViewController: UIViewController {

    @IBOutlet weak var messageView: UICollectionView!
    @IBOutlet weak var inputField: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    public var viewModel: MessageViewModelProtocol!
    
    private let BOTTOM_PADDING: CGFloat = 40 // magic number constant
    private let TXT_LEFT_PADDING: CGFloat = 12 // magic number constant
    private let MIN_HEIGHT: CGFloat = 50 // calculated from storyboard
    
    //MARK:- system methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindDependency()
        
        viewModel.loadStoreMessage()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        viewModel.updatedLastIndex()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let message = inputField.text, !message.isEmpty else { return }
        
        viewModel.hideTextView()
        viewModel.sendMessage(message)
    }
    
    deinit {
        print("What a cruel world!")
    }
}

// MARK:- CollectionView Layout Delegates
extension MessageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = viewModel.message(at: indexPath.item)
        
        let maxMsgWidth = ceil(0.8*collectionView.bounds.width)
        guard let estimatedRect = message?.text.estimatedFrame(at: maxMsgWidth) else { return .zero }
        return CGSize(width: messageView.bounds.width, height: estimatedRect.height + BOTTOM_PADDING)
    }
}

// MARK:- private methods
private extension MessageViewController {
    func configureView() {
        messageView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        
        inputField.textContainer.lineFragmentPadding = TXT_LEFT_PADDING
    }
    
    func bindDependency() {
        // bind title
        viewModel.title.bind(to: self.rx.title).disposed(by: viewModel.disposeBag)
        
        // tap gesture on collection view to text input
        messageView.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
        })
        .disposed(by: viewModel.disposeBag)
        
        // collection view bindings
        viewModel.messages.bind(to: messageView.rx.items(cellIdentifier: MessageCell.identifier, cellType: MessageCell.self)) {
            index, message, cell in
            cell.message = message
        }
        .disposed(by: viewModel.disposeBag)
        
        viewModel.lastIndexPath.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] indexPath in
            guard let _ws = self else { return }
            
            _ws.messageView.reloadData()
            _ws.messageView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
        .disposed(by: viewModel.disposeBag)
        
        messageView.rx.itemSelected.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        })
        .disposed(by: viewModel.disposeBag)
        
        messageView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        
        // input textview bindings
        inputField.rx.didBeginEditing.subscribe(onNext: { [weak self] _ in
            self?.viewModel.hideTextView(true)
        }).disposed(by: viewModel.disposeBag)
        
        inputField.rx.didEndEditing.subscribe(onNext: { [weak self] _ in
            self?.viewModel.hideTextView(!(self?.inputField.text.isEmpty)!)
        }).disposed(by: viewModel.disposeBag)
        
        inputField.rx.text.subscribe(onNext: { [weak self] txt in
            guard let width = self?.inputField.bounds.width,
                let font = self?.inputField.font,
                let height = txt?.estimatedFrame(at: width, font: font).height else { return }
            
            let padding: CGFloat = 34
            self?.textFieldHeight.constant = max(ceil(height)+padding, (self?.MIN_HEIGHT)!)
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }).disposed(by: viewModel.disposeBag)
        
        // input field configuration bindings
        viewModel.hiddenTextView
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] hidden in
                if !hidden {
                    self?.inputField.text = nil
                    self?.inputField.resignFirstResponder()
                    self?.textFieldHeight.constant = self?.MIN_HEIGHT ?? 0
                }
                
                self?.placeholderLabel.isHidden = hidden
            })
            .disposed(by: viewModel.disposeBag)
        
        // keyboard handle
            keyboardHeightObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboradHeight in
                self?.inputBottomConstraint.constant = -keyboradHeight
                
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self?.view.layoutIfNeeded()
                }, completion: { _ in
                    print("completion: keyboard animation done")
                    self?.viewModel.updatedLastIndex()
                })
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // observable for keyboard notifications
    func keyboardHeightObservable() -> Observable<CGFloat> {
        return Observable.from([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map {
                notification -> CGFloat in
                
                var keyboardHeight: CGFloat = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                if #available(iOS 11.0, *) {
                    keyboardHeight -= self.view.safeAreaInsets.bottom
                }
                
                return keyboardHeight
            },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map {
                _ -> CGFloat in
                0
            }
        ])
        .merge()
    }
}

//
//  MessageViewController.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindDependency()
        
        viewModel.loadStoreMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = viewModel.username
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        viewModel.layoutUpdated()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let message = inputField.text, !message.isEmpty else { return }
        
        adjustEmptyInputField()
        viewModel.sendMessage(message)
    }
    
    deinit {
        print("What a cruel world!")
        removeObserver()
    }
}

private extension MessageViewController {
    func configureView() {
        self.messageView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        
        inputField.textContainer.lineFragmentPadding = TXT_LEFT_PADDING
        
        let tap  = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.messageView.addGestureRecognizer(tap)
    }
    
    func bindDependency() {
        keyboardEventObserver()
        viewModel.onUpdateMessage = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.messageView.reloadData()
                self?.messageView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func adjustEmptyInputField(_ hidden: Bool = false) {
        if !hidden {
            inputField.text = nil
            inputField.resignFirstResponder()
            textFieldHeight.constant = MIN_HEIGHT
        }
        
        placeholderLabel.isHidden = hidden
    }
    
    func keyboardEventObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameChangeHandler(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameChangeHandler(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardFrameChangeHandler(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        var keyboardHeight = keyboardFrame.height
        if #available(iOS 11.0, *) {
            keyboardHeight -= self.view.safeAreaInsets.bottom
        }
        
        inputBottomConstraint.constant = isKeyboardShowing ? -keyboardHeight : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            if isKeyboardShowing {
                self?.viewModel.layoutUpdated()
            }
        })
    }
}

extension MessageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = messageView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        cell.message = viewModel.message(at: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = viewModel.message(at: indexPath.item)
        
        let maxMsgWidth = ceil(0.8*collectionView.bounds.width)
        guard let estimatedRect = message?.text.estimatedFrame(at: maxMsgWidth) else { return .zero }
        return CGSize(width: messageView.bounds.width, height: estimatedRect.height + BOTTOM_PADDING)
    }
}

extension MessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        adjustEmptyInputField(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        adjustEmptyInputField(!textView.text.isEmpty)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let padding: CGFloat = 34 // calculated from storyboard
        let height = ceil(textView.text.estimatedFrame(at: textView.bounds.width, font: textView.font!).height)
        textFieldHeight.constant = max(height+padding, MIN_HEIGHT)
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

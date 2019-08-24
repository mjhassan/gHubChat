//
//  UserCell.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    static let identifier = String(describing: UserCell.self)
    
    @IBOutlet weak var imgView: UIAsyncImageView?
    @IBOutlet weak var userLabel: UILabel?
    @IBOutlet weak var lastMsgLabel: UILabel?
    @IBOutlet weak var containerView: UIView? {
        didSet {
            containerView?.layer.cornerRadius = 5
            containerView?.layer.shadowOpacity = 0.5
            containerView?.layer.shadowRadius = 5
            containerView?.layer.shadowColor = UIColor.black.cgColor
            containerView?.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }
    
    private let defaultMessage = "Hi there! I'm using gHubChat."
    private let placeholder: UIImage? = UIImage(named: "placeholder")
    
    public var user: User? {
        didSet {
            guard let user = user else { return }
            
            imgView?.loadImage(from: user.avatar_url, placeholder: placeholder)
            userLabel?.text = "@\(user.login)"
            lastMsgLabel?.text = Store.shared.lastMessage(for: user.id) ?? defaultMessage
        }
    }
    
    public var userId: Int? {
        return user?.id
    }
}

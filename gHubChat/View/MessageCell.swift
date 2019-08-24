//
//  MessageCell.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    static let identifier = String(describing: MessageCell.self)
    
    static let IMG_INSETS = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
    static let left_bubble = UIImage(named: "left_bubble")!.resizableImage(withCapInsets: IMG_INSETS).withRenderingMode(.alwaysTemplate)
    static let right_bubble = UIImage(named: "right_bubble")!.resizableImage(withCapInsets: IMG_INSETS).withRenderingMode(.alwaysTemplate)
    
    private let offset: CGFloat = 4.0
    private let margin: CGFloat = 10.0
    
    private  lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MessageCell.right_bubble
        return imageView
    }()
    
    private lazy var messageView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .center
        return textView
    }()
    
    public var message: Message? {
        didSet {
            self.messageView.text = message?.text
            
            layoutNeedsUpdate()
        }
    }
    
    private var isRecieved: Bool {
        return message?.isRecieved ?? false
    }
    
    private var tintColorBubble: UIColor {
        return isRecieved ? UIColor(white: 0.7, alpha: 1):UIColor(red: 79/255, green: 143/255, blue: 234/255, alpha: 1)
    }
    
    private var bubble: UIImage {
        return isRecieved ? MessageCell.left_bubble:MessageCell.right_bubble
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutNeedsUpdate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageView.text = nil
    }
    
    private func configureView() {
        if !bubbleImageView.isDescendant(of: bubbleView) {
            bubbleView.addSubview(bubbleImageView)
        }
        
        if !messageView.isDescendant(of: bubbleView) {
            bubbleView.addSubview(messageView)
        }
        
        addSubview(bubbleView)
        
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    private func layoutNeedsUpdate() {
        guard let message = message,
            let width = self.collectionView?.bounds.width else { return }
        
        let maxTextWidth    = ceil(0.8*width)
        let estimatedFrame  = message.text.estimatedFrame(at: maxTextWidth)
        
        // update container view frame
        let containerWidth  = estimatedFrame.width + 2*(margin + offset)
        let containerHeight = estimatedFrame.height + 2*margin
        let xContainer      = isRecieved ? offset:(width - containerWidth - offset)
        let containerRect   = CGRect(x: xContainer, y: 0, width: containerWidth, height: containerHeight)
        bubbleView.frame    = containerRect
        
        // update message view frame; inside container "bubbleView"
        var msgFrame        = bubbleView.bounds
        msgFrame.origin.x   = isRecieved ? margin:offset/2
        msgFrame.size.width -= (margin+offset/2)
        messageView.frame   = msgFrame
        
        // update bubble and bubble color
        bubbleImageView.image = bubble
        bubbleImageView.tintColor = tintColorBubble
    }
}

//
//  UIAsyncImageView.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class UIAsyncImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        setImage(placeholder)
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        imageUrl = url
        
        Services().get(url: url) { [weak self] result in
            // sanity check
            guard let _imageUrl = self?.imageUrl, _imageUrl == url else {
                return
            }
            
            // data check
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self?.setImage(image)
                }
            case .failure(let err):
                print("ERROR: \(err.localizedDescription)")
            }
        }
    }
    
    private func setImage(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}

extension UIAsyncImageView {
    // MARK: - Associated Object properties
    // See: http://stackoverflow.com/questions/25907421/associating-swift-things-with-nsobject-instances
    final private var imageUrl: URL? {
        get {
            return objc_getAssociatedObject(self, &imageUrlCacheAssociationKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, &imageUrlCacheAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - UIImageView Associated Object Keys
private var imageUrlCacheAssociationKey: UInt8 = 0

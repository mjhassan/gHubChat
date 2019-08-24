//
//  UIAsyncImageView.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/19/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class UIAsyncImageView: UIImageView {
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    private let service: ServiceProtocol = Services()
    
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
        
        if let cachedImage = UIAsyncImageView.imageCache.object(forKey: url as AnyObject) as? UIImage {
            setImage(cachedImage)
            return
        }
        
        service.get(url: url) { [weak self] (data, error) in
            // sanity check
            guard let _imageUrl = self?.imageUrl, _imageUrl == url else {
                return
            }
            
            // data check
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            self?.setImage(image)
            UIAsyncImageView.imageCache.setObject(image, forKey: url as AnyObject)
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

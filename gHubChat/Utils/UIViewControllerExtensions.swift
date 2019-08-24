//
//  UIViewControllerExtension.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/21/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Associated Objects
    // See: http://stackoverflow.com/questions/25907421/associating-swift-things-with-nsobject-instances
    final private var spinner: UIView? {
        get {
            return objc_getAssociatedObject(self, &spinnerAssociationKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &spinnerAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.startAnimating()
        indicator.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicator)
            onView.addSubview(spinnerView)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        spinner = spinnerView
        
        // timeout action
        _ = Timer(timeInterval: 60, repeats: false) { [weak self] _ in
            self?.hideSpinner()
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner?.subviews.forEach({ $0.removeFromSuperview() })
            self?.spinner?.removeFromSuperview()
            self?.spinner = nil
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

// MARK: - UIButton Associated Object Keys
private var spinnerAssociationKey: UInt8 = 0


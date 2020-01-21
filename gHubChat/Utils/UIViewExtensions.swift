//
//  UIViewExtensions.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/20/19.
//  Here the permission is granted to this file with free of use anywhere in the IOS Projects.
//  Copyright © 2018 ABNBoys.com All rights reserved.
//

import UIKit

extension UIView {
    
    /** Adds Constraints in Visual Formate Language. It is a helper method defined in extensions for convinience usage
     
     - Parameter format: string formate as we give in visual formate, but view placeholders are like v0,v1, etc
     - Parameter views: It is a variadic Parameter, so pass the sub-views with "," seperated.
     */
    func addConstraintsWithVisualStrings(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /**
     Finds parentview / superview of specific type of a subview
     
     - @return: superview
     */
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    /**
     Finds subview of specific type in a parent view; which comes first
     
     - @return: subview
     */
    func childView<T: UIView>(of type: T.Type) -> T? {
        guard subviews.count != 0 else {
            return nil
        }
        
        return (self as? T) ?? self.subviews.compactMap { $0.childView(of: T.self) }.first
    }
}

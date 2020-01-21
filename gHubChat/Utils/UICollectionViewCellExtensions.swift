//
//  UICollectionViewCellExtensions.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        return parentView(of: UICollectionView.self)
    }
}

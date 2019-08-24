//
//  StringExtensions.swift
//  gHubChat
//
//  Created by Jahid Hassan on 8/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

extension String {
    func estimatedFrame(at width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 18)) -> CGRect {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox
    }
}

//
//  Data.swift
//  02.BuildingListsAndNavigation
//
//  Created by Jahid Hassan on 10/20/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

let userData: [User] = load("githubUsers.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        return try JSONDecoder().decode(type, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(type):\n\(error)")
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String:CGImage]
    fileprivate var images: _ImageDictionary = [:]
    fileprivate static var scale = 2
    
    static let shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index],
                     scale: CGFloat(ImageStore.scale),
                     label: Text(verbatim: name))
    }
    
    static func loadImage(name: String) -> CGImage {
        guard let image = UIImage(named: name) else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        
        return image.cgImage!
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

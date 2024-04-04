//
//  URLExtension.swift
//  SubscriptionApp
//
//  Created by José Guerra on 04-04-24.
//

import Foundation
import SwiftUI

extension URL {
    
    func loadImage(_ image: inout UIImage?) {
        if let data = try? Data(contentsOf: self), let loaded = UIImage(data: data) {
            image = loaded
        } else {
            image = nil
        }
    }
    
    
    func saveImage(_ image: UIImage?) {
        
        if let image = image {
            if let data = image.jpegData(compressionQuality: 1.0) {
                try? data.write(to: self)
            }
        } else {
            try? FileManager.default.removeItem(at: self)
        }
    }
}

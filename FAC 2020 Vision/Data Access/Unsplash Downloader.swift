//
//  Unsplash Downloader.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-11-27.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class UnsplashDownloader {
    
    let resolution = "1200x1200"
    let defaultImage = UIImage(named: "2020_background")
    
    /**
    Get months devotionals
    - Parameters:
        - unsplash_id: String of unsplash image ID
    - Returns: The devotions in an array
    */
    func getImage(unsplash_id: String, indexPath: IndexPath? = nil, completion: @escaping (UIImage?, IndexPath?, Error?) throws -> ()) {
        let url = self.getUnsplashURLWith(imageID: unsplash_id)
        
        if let image = UnsplashCache.photos[unsplash_id] {
            do {
                try completion(image, indexPath, nil)
            } catch {
                print("Could not get cached image, attempting to pull from unsplash")
            }
        }
        
        AF.request(url, method: .get).response { response in
            do {
                switch response.result {
                    case .success(let responseData):
                        let image = UIImage(data: responseData!)
                        UnsplashCache.photos[unsplash_id] = image
                        try completion(image, indexPath, nil)
                    case .failure(let error):
                        print("error--->",error)
                        try completion(self.defaultImage, indexPath, error)
                }
                
            } catch {
                print("Devo could not be cast")
            }
        }
    }

    
    private func getUnsplashURLWith(imageID: String?) -> URL {
        if let imageID = imageID {
            return URL(string: "https://source.unsplash.com/" + imageID + "/" + resolution)!
        } else {
            return URL(string: "https://source.unsplash.com/gn_nY1uptlg/" + resolution)!
        }
    }
}

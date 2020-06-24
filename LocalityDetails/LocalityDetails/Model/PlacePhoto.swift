//
//  PlacePhoto.swift
//  LocalityDetails
//
//  Created by fkhader on 6/25/20.
//  Copyright © 2020 fkhader. All rights reserved.
//

import UIKit

class PlacePhoto: Equatable {
    
    static func == (lhs: PlacePhoto, rhs: PlacePhoto) -> Bool {
        return lhs.imageHerf == rhs.imageHerf

    }
    
    enum Error: Swift.Error {
        case invalidURL
        case noData
    }
    
    var thumbnail: UIImage?
    var largeImage: UIImage?
    var imageHerf: String
    
    init(imageHerf: String) {
        self.imageHerf = imageHerf
    }
    
    func imageURL(string: String) -> URL?{
        if let url =  URL(string: "\(string)") {
            return url
        }
        return nil
    }
    
    func loadLargeImage(_ completion: @escaping (Result<PlacePhoto>) -> Void) {
        guard let loadURL:URL = imageURL(string: self.imageHerf) else {
            DispatchQueue.main.async {
                completion(Result.error(Error.invalidURL))
            }
            return
        }
        
        let loadRequest = URLRequest(url:loadURL)
        
        URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.error(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(Result.error(Error.noData))
                }
                return
            }
            
            let returnedImage = UIImage(data: data)
            self.largeImage = returnedImage
            DispatchQueue.main.async {
                completion(Result.results(self))
            }
            }.resume()
    }
    
    func sizeToFillWidth(of size:CGSize) -> CGSize {
        guard let thumbnail = thumbnail else {
            return size
        }
        
        let imageSize = thumbnail.size
        var returnSize = size
        
        let aspectRatio = imageSize.width / imageSize.height
        
        returnSize.height = returnSize.width / aspectRatio
        
        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }
        return returnSize
    }
}

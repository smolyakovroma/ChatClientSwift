//
//  Utility.swift
//  ChatClient
//
//  Created by Роман Смоляков on 06/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit

class Utility {
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        //        let scale = newWidth / image.size.width
        //        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
//    static func saveToJsonFile(data: Data, address: String, completion: @escaping (String) -> Void) {
//
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileUrl = documentDirectoryUrl.appendingPathComponent("UnicornGoKey" + address + ".json")
//
//        do {
//            try data.write(to: fileUrl, options: [])
//            completion(fileUrl.absoluteString)
//        } catch {
//            print(error)
//            completion("")
//        }
//    }
    
    static let imageCache = NSCache<NSString, AnyObject>()
    
    static func loadImageWithCache(withUrl urlString : String, returnCompletion: @escaping (UIImage) -> ()) {
        
        let url = URL(string: urlString)
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            //                self.image = cachedImage
            returnCompletion(cachedImage)
            //            return cachedImage
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                // Background work
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    returnCompletion(image)
                }
            }
            
        }).resume()
        
    }
    
    static func getImageFromBase64(str: String) -> UIImage {
        if !str.isEmpty{
            let dataDecoded:NSData = NSData(base64Encoded: str, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            return decodedimage
        }
        return UIImage(named: "empty-logo-user")!
    }
}

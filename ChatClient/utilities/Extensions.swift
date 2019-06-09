//
//  Extensions.swift
//  ChatClient
//
//  Created by Роман Смоляков on 06/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
//    func leftPadding(toLength: Int, withPad: String = " ") -> String {
//
//        guard toLength > self.characters.count else { return self }
//
//        let padding = String(repeating: withPad, count: toLength - self.characters.count)
//        return padding + self
//    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        return String(utf16CodeUnits: chars, count: chars.count)
    }
    
    //    var millisecondsSince1970:Int {
    //        return Int((self.1970 * 1000.0).rounded())
    //    }
    //
    //    init(milliseconds:Int) {
    //        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    //    }
}


//extension Request {
//    public func debugLog() -> Self {
//        #if DEBUG
//        debugPrint("=======================================")
//        debugPrint(self)
//        debugPrint("=======================================")
//        #endif
//        return self
//    }
//}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    
    
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        let v = sizeThatFits.height
//        sizeThatFits.height = v
//
//        return sizeThatFits
//    }
//}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + 50
        return sizeThatFits
    }
}

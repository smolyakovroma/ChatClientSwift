//
//  CardView.swift
//  ChatClient
//
//  Created by Роман Смоляков on 02/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerradius :CGFloat = 10
    @IBInspectable var shadowOffSetWidth :CGFloat = 1
    @IBInspectable var shadowOffSetHeight :CGFloat = 3
    @IBInspectable var shadowColor :UIColor = UIColor.black
    @IBInspectable var shadowOpacity :CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}

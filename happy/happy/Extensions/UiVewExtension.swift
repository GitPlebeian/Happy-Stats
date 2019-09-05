//
//  UiVewExtension.swift
//  happy
//
//  Created by Jackson Tubbs on 9/3/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

extension UIView {
    func anchor (top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

struct SpacingConstants {
    static let verticalObjectBuffer: CGFloat = 8.0
    static let outerHorizontalPadding: CGFloat = 24.0
    static let outerVerticalPadding: CGFloat = 16.0
    static let oneLineElementHight: CGFloat = 24.0
    static let twoLineElementHieght: CGFloat = 32
}

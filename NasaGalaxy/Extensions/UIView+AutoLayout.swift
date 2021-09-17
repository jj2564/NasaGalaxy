//
//  UIView+AutoLayout.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/17.
//

import UIKit

extension UIView {
    /// 貼邊放入SuperView
    func edgeWithSuperView(_ padding: UIEdgeInsets = .zero, priority: Int = 1000) {
        translatesAutoresizingMaskIntoConstraints = false
        let views: ViewsDictionary = ["v0": self]
        
        let top = padding.top
        let bot = padding.bottom
        let left = padding.left
        let right = padding.right
        
        let vfls: VFLDictionary = [
            "H:|-(\(left)@\(priority))-[v0]-(\(right)@\(priority))-|": nil,
            "V:|-(\(top)@\(priority))-[v0]-(\(bot)@\(priority))-|": nil
        ]
        var constraints = [NSLayoutConstraint]()
        constraints += constraintsArrayVFL(vfls, views: views)
        NSLayoutConstraint.activate(constraints)
    }
}

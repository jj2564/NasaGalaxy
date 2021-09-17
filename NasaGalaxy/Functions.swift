//
//  Functions.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

// 專案內會用到的常用Functions

import Foundation
import UIKit

/// VFL語言 縮減排版
func constraintsVFL(_ vfl: String, views: [String: Any], metrics: [String: CGFloat]? = nil, options: NSLayoutConstraint.FormatOptions = []) -> [NSLayoutConstraint] {
    return NSLayoutConstraint.constraints(withVisualFormat:vfl,options: options, metrics: metrics, views: views)
}

/// VFL語言 縮減排版
func constraintsArrayVFL(_ vfls: VFLDictionary, views: [String: Any], metrics: [String: CGFloat]? = nil) -> [NSLayoutConstraint] {
    
    var constraints = [NSLayoutConstraint]()
    
    for (vfl, options) in vfls {
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vfl, options: options ?? [], metrics: metrics, views: views)
    }
    
    return constraints
}

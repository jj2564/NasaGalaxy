//
//  NavigationController+PushAction.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/17.
//

import UIKit

extension UINavigationController {
    
    func pushVC(_ vc: UIViewController, animated: Bool = true) {
        pushWithoutCount( 0, vc: vc, animated: animated)
    }
    
    func pushWithoutCount(_ count: Int, vc: UIViewController, animated: Bool = true) {
        var vcs = viewControllers
        for _ in 0 ..< count {
            if vcs.count > 0 {
                vcs.removeLast()
            } else { break }
        }
        vcs.append(vc)
        setViewControllers( vcs, animated: true)
    }
}

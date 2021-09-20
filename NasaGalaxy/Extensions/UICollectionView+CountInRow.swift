//
//  UICollectionView+Row.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/20.
//

import UIKit

extension UICollectionView {
    static var countInRow: (_ verticalSize: UIUserInterfaceSizeClass, _ horizontalSize: UIUserInterfaceSizeClass) -> Int {
        {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.regular, .compact): // iPhone portrait
                return 4
            case (.compact, .regular), (.compact, .compact): // iPhone landscape
                return 6
            case (.regular, .regular): // iPad portrait/landscape
                return 8
            default:
                return 4
            }
        }
    }
}

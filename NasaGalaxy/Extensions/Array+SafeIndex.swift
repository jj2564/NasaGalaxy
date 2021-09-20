//
//  Array+SafeIndex.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/18.
//

import Foundation

extension Array {
    /// Array防呆
    subscript(safe index: Int) -> Element? {
        if !indices.contains(index) { return nil }
        return self[index]
    }
}

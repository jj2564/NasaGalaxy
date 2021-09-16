//
//  Dictionary+Data.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//
import Foundation
extension Dictionary {
    /// 將Dictionary轉成Data
    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}

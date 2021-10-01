//
//  DateFormatter+Format.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/10/1.
//

import Foundation

extension DateFormatter {
    static let orginFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    static let resultFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy MMM. dd"
        return df
    }()
}

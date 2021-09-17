//
//  NasaLabel.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/17.
//

import UIKit

class NasaLabel: UILabel {
    
    private var labelType: LabelType = .none
    
    required init( type: LabelType ) {
        super.init(frame: .zero)
        labelType = type
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        
        font = labelType.font
        textColor = labelType.textColor
        textAlignment = labelType.alignment
    }
}


extension NasaLabel {
    enum LabelType {
        case home
        case none
        
        var font: UIFont {
            switch self {
            case .home: return .systemFont(ofSize: 25, weight: .bold)
            default: return .systemFont(ofSize: 14)
            }
        }
        
        var textColor: UIColor {
            switch self {
            default: return .black
            }
        }
        
        var alignment: NSTextAlignment {
            switch self {
            case .home: return .center
            default: return .left
            }
        }
    }
}

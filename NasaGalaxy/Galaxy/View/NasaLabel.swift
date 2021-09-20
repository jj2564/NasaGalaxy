//
//  NasaLabel.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/17.
//

import UIKit

class NasaLabel: UILabel {
    
    private var labelType: LabelType = .basic
    
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
        case list
        case detail
        case basic
        
        var font: UIFont {
            switch self {
            case .home: return .systemFont(ofSize: 25, weight: .bold)
            case .list: return .systemFont(ofSize: 17, weight: .regular)
            case .detail: return .systemFont(ofSize: 18, weight: .light)
            default: return .systemFont(ofSize: 15)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .list: return .white
            default: return .black
            }
        }
        
        var alignment: NSTextAlignment {
            switch self {
            case .home, .list, .detail: return .center
            default: return .left
            }
        }
    }
}

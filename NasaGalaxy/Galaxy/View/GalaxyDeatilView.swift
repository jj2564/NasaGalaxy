//
//  GalaxyDeatilView.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/18.
//

import UIKit

class GalaxyDeatilView: UIStackView {
    
    public func updateData(_ data: GalaxyData ) {
        dateLabel.text = data.date
        titleLabel.text = data.title
        copyrightLabel.text = data.copyright
        contentLabel.text = data.description
        hdImageView.fetchImage(data.hdURL, isHd: true) { _ in }
    }
    
    private lazy var dateLabel = NasaLabel(type: .detail)
    private lazy var titleLabel = NasaLabel(type: .detail)
    private lazy var copyrightLabel = NasaLabel(type: .detail)
    private lazy var contentLabel = NasaLabel(type: .basic)
    
    private lazy var hdImageView = AsyncImageView()
    
    required init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        spacing = 10
        setupViews()
    }
    
    private func setupViews() {
        addArrangedSubview(dateLabel)
        addArrangedSubview(titleLabel)
        addArrangedSubview(hdImageView)
        addArrangedSubview(copyrightLabel)
        addArrangedSubview(contentLabel)
        
        for view in subviews {
            if view is UILabel {
                view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
            }
        }
        
        hdImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        hdImageView.contentMode = .scaleAspectFit
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

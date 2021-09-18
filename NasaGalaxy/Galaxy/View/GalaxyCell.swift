//
//  GalaxyCell.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/18.
//

import UIKit

class GalaxyCell: UICollectionViewCell {
    static let cellIdentifier = "GalaxyCell"
    
    let view = GalaxyView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(view)
        view.edgeWithSuperView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.imageView.image = nil
        view.titleLabel.text = ""
    }
}

class GalaxyView: UIView {
    
    public func updateData(data: GalaxyData) {
        self.data = data
        titleLabel.isHidden = !imageView.isValidImage
        
        imageView.fetchImageWithURL(data.url) { [weak self] _ in
            self?.titleLabel.isHidden = false
        }
        titleLabel.text = data.title
    }
    
    lazy var imageView = AsyncImageView()
    lazy var titleLabel = NasaLabel(type: .list)
    
    var data: GalaxyData?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        titleLabel.isHidden = true
    }
    
    private func setupLayout() {
        imageView.edgeWithSuperView()
        titleLabel.edgeWithSuperView(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
}

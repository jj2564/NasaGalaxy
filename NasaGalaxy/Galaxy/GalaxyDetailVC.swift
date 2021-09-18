//
//  GalaxyDetailVC.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/18.
//

import UIKit
import Foundation

class GalaxyDetailVC: UIViewController {
    
    public var data: GalaxyData!
    
    private lazy var galaxyScrollView = createScrollView()
    private lazy var galaxyDetailView = GalaxyDeatilView()
    /// galaxyDetailView的width
    private var widthConstraint = NSLayoutConstraint()
    
    override func loadView() {
        super.loadView()
        setup()
    }

    private func setup() {
        navigationItem.title = data.title
        view.backgroundColor = .white
        view.addSubview(galaxyScrollView)
        galaxyScrollView.edgeWithSuperView()
        
        galaxyScrollView.addSubview(galaxyDetailView)
        galaxyDetailView.edgeWithSuperView()
        galaxyDetailView.updateData(data)
        
        widthConstraint = galaxyDetailView.widthAnchor.constraint(equalTo: view.widthAnchor)
        widthConstraint.isActive = true
    }
}

extension GalaxyDetailVC {
    private func createScrollView() -> UIScrollView {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        return v
    }
}

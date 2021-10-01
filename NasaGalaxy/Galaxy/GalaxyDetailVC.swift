//
//  GalaxyDetailVC.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/18.
//

import UIKit
import Foundation

class GalaxyDetailVC: UIViewController {
    
    public func setupData(_ data: GalaxyData) {
        self.data = data
    }
    
    private var data: GalaxyData? {
        didSet {
            updateView()
        }
    }
    
    private lazy var galaxyScrollView = createScrollView()
    private lazy var galaxyDetailView = GalaxyDeatilView()
    /// galaxyDetailView的width
    private var widthConstraint = NSLayoutConstraint()
    
    override func loadView() {
        super.loadView()
        setup()
        updateView()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(galaxyScrollView)
        galaxyScrollView.edgeWithSuperView()
        galaxyScrollView.addSubview(galaxyDetailView)
        galaxyDetailView.edgeWithSuperView()
        widthConstraint = galaxyDetailView.widthAnchor.constraint(equalTo: view.widthAnchor)
        widthConstraint.isActive = true
    }
    
    private func updateView() {
        guard let data = data else { return }

        navigationItem.title = data.title
        galaxyDetailView.updateData(data)
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

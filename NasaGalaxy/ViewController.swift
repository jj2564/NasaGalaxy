//
//  ViewController.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

// 首頁
// 這頁比較單純就一個VC就下去了

import UIKit
import Foundation

class ViewController: UIViewController {
    // MARK:- Views
    private lazy var baseView = createView()
    private lazy var titleLabel = NasaLabel(type: .home)
    private lazy var pushButton = createButton()
    
    override func loadView() {
        super.loadView()
        setupVC()
        setupViews()
        setupLayout()
    }
    
    private func setupVC() {
        navigationItem.title = "NasaGalaxy"
    }
    
    private func setupViews() {
        view.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(pushButton)
        
        titleLabel.text = "Astronomy Picture of the Day"
        pushButton.setTitle("Request", for: .normal)
    }
    
    private func setupLayout() {
        baseView.edgeWithSuperView()
        
        let views: ViewsDictionary = [
            "title": titleLabel,
            "btn": pushButton
        ]
        
        let vfls: VFLDictionary = [
            "H:|-(8)-[title]-(8)-|": [],
            "H:|-(8)-[btn]-(8)-|": [],
            "V:[title]-(20)-[btn]-(>=20)-|": .alignAllCenterX
        ]
        
        var constraints = constraintsArrayVFL(vfls, views: views)
        let topGap = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: baseView, attribute: .bottom, multiplier: 0.4, constant: 0)
        constraints += [topGap]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ViewController {
    
    private func createView() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }
    
    private func createButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(pushPage), for: .touchUpInside)
        btn.setTitleColor( .systemBlue, for: .normal)
        return btn
    }
    
    @objc private func pushPage() {
        navigationController?.pushVC( GalaxyListVC() )
    }
}


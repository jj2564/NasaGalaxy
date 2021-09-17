//
//  GalaxyListVC.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/17.
//

import UIKit
import Foundation

class GalaxyListVC: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let req = GetGalaxyData()
        ApiManager.share.fetch(from: req) { result in
            switch result {
            case .success(let data):
                if data.count > 0 {
                    print(data.first?.title ?? "")
                }
            case .failure(let error):
                print(error.message)
            }
        }
    }
}

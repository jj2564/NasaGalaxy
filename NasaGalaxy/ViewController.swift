//
//  ViewController.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let req = ApiRequest.init(urlString: "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json")
        ApiManager.request(from: req) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode([GalaxyData].self, from: data)

                    if model.count > 0 {
                        print(model.first?.title ?? "")
                    }
                    
                } catch let error {
                    print(error)
                }
            default: break
            }


        }
    }
}


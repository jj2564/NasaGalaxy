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
                    let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                    print(object)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                break
            }


        }
        
//        if let urlString = "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
//           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//              if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                 print(json)
//              }
//           }
//           task.resume()
//        }
    }


}


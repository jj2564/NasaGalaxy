//
//  GalaxyListViewModel.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/20.
//
import UIKit
import Foundation

class GalaxyListViewModel {
    
    init() {}
    
    var datas: [GalaxyData] = []
    var reloadHandler: (() -> Void)?
    
    struct GalaxyListRequest: ApiRequest {
        typealias Response = [GalaxyData]
        var urlString: String = "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json"
    }
    
    public func fetchData() {
        let req = GalaxyListRequest()
        ApiManager.fetch(from: req) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.configureModel(list: data)
            case .failure(let error):
                print(error.message)
            }
        }
    }
    
    private func configureModel(list: [GalaxyData]) {
        self.datas = list
        self.reloadHandler?()
    }
}

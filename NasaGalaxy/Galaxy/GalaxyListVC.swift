//
//  GalaxyListVC.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/17.
//
// 應該可以支援所有螢幕的Size包括iPad以及轉向

import UIKit
import Foundation

class GalaxyListVC: UIViewController {
    
    private var dataList: [GalaxyData] = []
    private lazy var galaxyCollectionView: UICollectionView = createCollection()
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Galaxy Collections"
        
        view.addSubview(galaxyCollectionView)
        galaxyCollectionView.edgeWithSuperView()
        updateCollectionLayout()
        getData()
    }
    
    deinit {
        print("GalaxyListVC deinit")
    }
    
    private func getData() {
        let req = GalaxyDataRequest()
        ApiManager.fetch(from: req) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.dataList = data
                self.galaxyCollectionView.reloadData()
            case .failure(let error):
                print(error.message)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateCollectionLayout()
    }
}

extension GalaxyListVC {
    private func createCollection() -> UICollectionView {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(GalaxyCell.self, forCellWithReuseIdentifier: GalaxyCell.cellIdentifier)
        return cv
    }
    
    private func updateCollectionLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        let spacing = CGFloat(1.5)
        let span = UICollectionView.countInRow(traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass)
        let total = CGFloat(span - 1) * spacing
        let width = (UIScreen.width - total) / CGFloat(span)
        let height = width
        let itemSize = CGSize(width: width, height: height)
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = itemSize
        
        galaxyCollectionView.setCollectionViewLayout(flowLayout, animated: true);
    }
}

extension GalaxyListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalaxyCell.cellIdentifier, for: indexPath) as! GalaxyCell
        if let data = dataList[safe: indexPath.row] {
            cell.view.updateData(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = dataList[safe: indexPath.row] else { return }
        let vc = GalaxyDetailVC()
        vc.data = data
        navigationController?.pushVC(vc)
    }
}

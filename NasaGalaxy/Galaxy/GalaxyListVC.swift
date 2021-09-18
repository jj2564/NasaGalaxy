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
    private var countInRow: (_ verticalSize: UIUserInterfaceSizeClass, _ horizontalSize: UIUserInterfaceSizeClass) -> Int {
        {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.regular, .compact): // iPhone portrait
                return 4
            case (.compact, .regular), (.compact, .compact): // iPhone landscape
                return 6
            case (.regular, .regular): // iPad portrait/landscape
                return 8
            default:
                return 4
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Galaxy Collections"
        
        view.addSubview(galaxyCollectionView)
        galaxyCollectionView.edgeWithSuperView()
        updateCollectionLayout()
        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
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
    
    @objc func rotated() {
        updateCollectionLayout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        print("GalaxyListVC deinit")
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
        let span = countInRow(traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass)
        let total = CGFloat(span - 1) * spacing
        let width = (UIScreen.main.bounds.width - total) / CGFloat(span)
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
    
    // 好像有的時候還是會發生Timeout之後仍然show出文字
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalaxyCell.cellIdentifier, for: indexPath) as! GalaxyCell
        if let data = dataList[safe: indexPath.row] {
            cell.view.imageView.fetchImageWithURL(data.url) { _ in
                cell.view.titleLabel.isHidden = false
            }
            cell.view.titleLabel.text = data.title
            cell.view.titleLabel.isHidden = !cell.view.imageView.isValidImage
        }
        return cell
    }
}

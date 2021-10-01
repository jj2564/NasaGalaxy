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
    
    private var viewModel = GalaxyListViewModel()
    private lazy var galaxyCollectionView: UICollectionView = createCollection()
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Galaxy Collections"
        
        view.addSubview(galaxyCollectionView)
        galaxyCollectionView.edgeWithSuperView()
        updateCollectionLayout()
        setupViewModel()
    }
    
    deinit {
        print("GalaxyListVC deinit")
    }
    
    private func setupViewModel() {
        // Binding update
        viewModel.reloadHandler = { [weak self] in
            guard let self = self else { return }
            self.galaxyCollectionView.reloadData()
        }
        updateData()
    }
    
    private func updateData() {
        self.viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        updateCollectionLayout()
        galaxyCollectionView.snapshotView(afterScreenUpdates: true)
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
        viewModel.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalaxyCell.cellIdentifier, for: indexPath) as! GalaxyCell
        if let data = viewModel.datas[safe: indexPath.row] {
            cell.view.updateData(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel.datas[safe: indexPath.row] else { return }
        let vc = GalaxyDetailVC()
        vc.setupData(data)
        navigationController?.pushVC(vc)
    }
}

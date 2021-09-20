//
//  AsyncImageView.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/18.
//

import UIKit
import Foundation

let cache = NSCache<NSString, UIImage>()

class AsyncImageView: UIImageView {
 
    var url: URL?
    var isValidImage: Bool {
        guard let url = url else { return false }
        let name = url.lastPathComponent
        let key = NSString(string: name)
        if let _ = cache.object(forKey: key) {
            return true
        }
        return false
    }
    
    private lazy var heightConstraint = NSLayoutConstraint()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetchImage(_ url: URL?, isHd: Bool = false, completion: @escaping ((Bool) -> Void)) {
        self.url = url
        
        let placeholder = #imageLiteral(resourceName: "image_default")
        let err = #imageLiteral(resourceName: "image_failed")
        
        image = placeholder
        
        guard let url = url else {
            image = err
            completion(false)
            return
        }
        
        let name = url.lastPathComponent
        let key = NSString(string: name)
        if let image = cache.object(forKey: key) {
            self.image = image
            completion(true)
            return
        }
        
        ApiManagerURLSession.share.fetchImageWithURL(url, isHd: isHd) { [weak self] result, responseURL in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cache.setObject(image, forKey: key)
                    if self.url == responseURL {
                        self.image = image
                        self.updateHeight(image)
                        completion(true)
                    }
                case .failure(_):
                    if self.url == responseURL {
                        self.image = err
                        completion(false)
                    }
                }
            }
            
        }
    }
    
    /// 在StackView的時候整個空間跳高，因此修飾高度
    private func updateHeight( _ image: UIImage) {
        if contentMode == .scaleAspectFit {
            heightConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: image.size.height / image.size.width)
            heightConstraint.isActive = true
        } else {
            heightConstraint.isActive = false
        }
    }
}

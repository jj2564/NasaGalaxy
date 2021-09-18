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
    private var session: URLSession!
    /// 超時時間限制，value = 10
    private let timeout: TimeInterval = 10
    
    var isValidImage: Bool {
        guard let url = url else { return false }
        let name = url.lastPathComponent
        let key = NSString(string: name)
        if let _ = cache.object(forKey: key) {
            return true
        }
        return false
    }
    
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
        
        let config: URLSessionConfiguration = .default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        config.networkServiceType = .background
        session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchImageWithURL(_ url: URL?, completion: @escaping ((UIImage) -> Void) ) {
        
        self.url = url
        let placeholder = #imageLiteral(resourceName: "image_default")
        image = placeholder
        
        let err = #imageLiteral(resourceName: "image_failed")
        guard let url = url else {
            image = err
            return
        }
        
        let name = url.lastPathComponent
        let key = NSString(string: name)
        if let image = cache.object(forKey: key) {
            self.image = image
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            var currentURL = response?.url
            if let data = data, let image = UIImage(data: data) {
                cache.setObject(image, forKey: key)
                if self.url == currentURL {
                    DispatchQueue.main.async {
                        self.image = image
                        completion(image)
                    }
                }
                return
            }
            
            if let errorDict = (error as NSError?)?.userInfo,
               let url = errorDict["NSErrorFailingURLKey"] as? URL {
                currentURL = url
            }
            
            if self.url == currentURL  {
                DispatchQueue.main.async {
                    self.image = err
                }
            }
        }
        task.resume()
    }
}

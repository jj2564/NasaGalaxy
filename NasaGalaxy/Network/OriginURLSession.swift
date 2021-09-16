//
//  OriginURLSession.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

import Foundation

class OriginURLSession: NSObject {
    
    static let share = OriginURLSession()
    
    private var session: URLSession!
    /// 儲存req用，因為在移除重複的時候可能遇到多執行序，所以要採thread safe
    private var tasks: ThreadSafeDictionary<ApiRequest, URLSessionDataTask> = [:]
    /// 超時時間限制，value = 10
    private let timeout: TimeInterval = 10
    
    private override init() {
        super.init()
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        config.networkServiceType = .background
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    public func fetch(from req: ApiRequest, completion: Completion?) {
        let reachability = try? Reachability()
        guard let r = reachability, r.isConnectedToNetwork else {
            completion?(.failure(ApiError.networkError))
            return
        }
        guard let url = req.url else {
            completion?(.failure(ApiError.invalidUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeout
        
        // 若是ApiRequest重複就取消上一次的task
        if let task = tasks[req] {
            task.cancel()
            _ = tasks.removeValue(forKey: req)
        }
        
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            guard let _ = (response as? HTTPURLResponse)?.statusCode else {
                completion?(.failure(ApiError.networkError))
                return
            }
            
            if self.tasks[req] != nil {
                _ = self.tasks.removeValue(forKey: req)
            }
            
            if let _ = error {
                completion?(.failure(ApiError.networkError))
                return
            }
            
            guard let data = data else {
                completion?(.failure(ApiError.nilData))
                return
            }
            
            completion?(.success(data))
        }
        
        tasks[req] = task
        task.resume()
    }
    
    /// 取消目前連線
    public func cancel(in req: ApiRequest) {
        tasks[req]?.cancel()
        print("⛔️ Cancel \(String(describing: tasks[req]))")
        _ = tasks.removeValue(forKey: req)
    }
    
    /// 取消目前所有連線
    public func cancelAll() {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
}

extension OriginURLSession: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
    
    // Send Data
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64, totalBytesExpectedToSend: Int64) { }
    
    // Download Data
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) { }
}

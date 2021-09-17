//
//  ApiManager.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

// 這是以前寫來對應api的精簡版

import Foundation

/// Api callback `completion`
typealias Completion = (Result<Data, ApiError>) -> Void
let decoder = JSONDecoder()

enum ApiError: Error {
    
    case networkError
    
    case invalidUrl
    
    case nilData
    
    case jsonError
    
    var message: String {
        switch self {
        case .networkError: return "網路連線錯誤"
        case .invalidUrl: return "網址錯誤"
        case .nilData: return "無資料"
        case .jsonError: return "JSON解析錯誤"
        }
    }
}

protocol ApiRequest: Hashable {
    associatedtype Response: Decodable
    var urlString: String { get set }
    var url: URL? { get }
}

extension ApiRequest {
    var url: URL? { URL(string: urlString) }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(urlString)
    }
    // 比對 urlString
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.urlString == rhs.urlString
    }
}

class ApiManager: NSObject {
    
    static let share = ApiManager()
    
    private var session: URLSession!
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
    
    public func fetch<Req: ApiRequest>(from req: Req, completion: @escaping (Result<Req.Response, ApiError>) -> Void) {
        let reachability = try? Reachability()
        guard let r = reachability, r.isConnectedToNetwork else {
            completion(.failure(ApiError.networkError))
            return
        }
        guard let url = req.url else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeout
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let _ = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(ApiError.networkError))
                return
            }
            
            if let _ = error {
                completion(.failure(ApiError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.nilData))
                return
            }
            
            guard let value = try? decoder.decode(Req.Response.self, from: data) else {
                completion(.failure(ApiError.jsonError))
                return
            }
            completion(.success(value))
        }
        
        task.resume()
    }
    

}

extension ApiManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
    
    // Send Data
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64, totalBytesExpectedToSend: Int64) { }
    
    // Download Data
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) { }
}

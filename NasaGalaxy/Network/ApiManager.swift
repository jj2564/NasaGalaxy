//
//  ApiManager.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

// 這是以前寫來對應api的精簡版
import UIKit
import Foundation

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

struct ApiManager {
    
    public static func fetch<Req: ApiRequest>(from req: Req, completion: @escaping (Result<Req.Response, ApiError>) -> Void ) {
        ApiManagerURLSession.share.fetch(from: req) { result in
            switch result {
            case .success(let req):
                DispatchQueue.main.async {
                    completion(.success(req))
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
        }
    }
}

class ApiManagerURLSession: NSObject {
    
    let decoder = JSONDecoder()
    static let share = ApiManagerURLSession()
    
    public func fetch<Req: ApiRequest>(from req: Req, completion: @escaping (Result<Req.Response, ApiError>) -> Void ) {
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
        urlRequest.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
            
            guard let value = try? self.decoder.decode(Req.Response.self, from: data) else {
                completion(.failure(ApiError.jsonError))
                return
            }
            completion(.success(value))
        }
        
        task.resume()
    }
    
    public func fetchImageWithURL(_ url: URL?, isHd: Bool = false, completion: @escaping ((Result<UIImage, ApiError>, URL?) -> Void) ) {
        guard let url = url else {
            completion(.failure(.invalidUrl), nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = isHd ? 999 : 30
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            var currentURL = response?.url
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image), currentURL)
                return
            }
            
            if let errorDict = (error as NSError?)?.userInfo,
               let url = errorDict["NSErrorFailingURLKey"] as? URL {
                currentURL = url
            }
            completion(.failure(.nilData), currentURL)
        }
        task.resume()
    }
}

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

enum ApiError: Error {
    
    case networkError
    
    case invalidUrl
    
    case nilData
    
    var message: String {
        switch self {
        case .networkError: return "網路連線錯誤"
        case .invalidUrl: return "網址錯誤"
        case .nilData: return "無資料"
        }
    }
}

/// Http Request
public struct ApiRequest: Hashable {
    
    var url: URL? { URL(string: urlString) }
    
    private var urlString: String = ""
    
    init( urlString: String) {
        self.urlString = urlString
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(urlString)
    }
    // 比對 urlString
    public static func == (lhs: ApiRequest, rhs: ApiRequest) -> Bool {
        return  lhs.urlString == rhs.urlString
    }
}

struct ApiManager {
    
    private init() {}
    
    public static func request(from req: ApiRequest, completion: Completion?) {
        
        OriginURLSession.share.fetch(from: req) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion?(.success(data))
                }
            case .failure(let err):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    completion?(.failure(err))
                })
            }
        }
    }
    /// 取消目前連線
    public static func cancel(in req: ApiRequest) {
        OriginURLSession.share.cancel(in: req)
    }
    
    /// 取消目前所有連線
    public static func cancelAll() {
        OriginURLSession.share.cancelAll()
    }
}

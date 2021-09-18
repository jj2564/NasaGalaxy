//
//  GalaxyData.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

import Foundation

struct GalaxyDataRequest: ApiRequest {
    typealias Response = [GalaxyData]
    var urlString: String = "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json"
}

struct GalaxyData: Decodable {
    
    var description: String = ""
    var copyright: String = ""
    var title: String = ""
    var url: URL?
    var apodSite: String = ""
    var date: String = ""
    var mediaType: String = ""
    var hdURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case description,copyright, title, url, date
        case apodSite = "apod_site"
        case mediaType = "media_type"
        case hdURL = "hdurl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        copyright = try container.decodeIfPresent(String.self, forKey: .copyright) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        let urlString = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        url = URL(string: urlString)
        apodSite = try container.decodeIfPresent(String.self, forKey: .apodSite) ?? ""
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType) ?? ""
        let hdURLString = try container.decodeIfPresent(String.self, forKey: .hdURL) ?? ""
        hdURL = URL(string: hdURLString)
    }
    
    init() {}
}

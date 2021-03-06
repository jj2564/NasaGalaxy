//
//  GalaxyData.swift
//  NasaGalaxy
//
//  Created by IrvingHuang on 2021/9/16.
//

import Foundation

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
        copyright = "Credit & Copyright: " + copyright
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        let urlString = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        url = URL(string: urlString)
        apodSite = try container.decodeIfPresent(String.self, forKey: .apodSite) ?? ""
        let oriDateString = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        
        if let oriDate = DateFormatter.orginFormatter.date(from: oriDateString) {
            date = DateFormatter.resultFormatter.string(from: oriDate)
        } else {
            date = oriDateString
        }
        
        mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType) ?? ""
        let hdURLString = try container.decodeIfPresent(String.self, forKey: .hdURL) ?? ""
        hdURL = URL(string: hdURLString)
    }
    
    init() {}
}


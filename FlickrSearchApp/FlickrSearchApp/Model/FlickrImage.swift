//
//  FlickrImage.swift
//  FlickrSearchApp
//
//  Created by Asaf Ahmed on 7/2/24.
//

import Foundation
struct FlickrImage: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let media: Media
    let description: String
    let author: String
    let published: String

    enum CodingKeys: String, CodingKey {
        case title, description, author, published
        case media = "media"
    }

    struct Media: Decodable {
        let m: String
    }
}

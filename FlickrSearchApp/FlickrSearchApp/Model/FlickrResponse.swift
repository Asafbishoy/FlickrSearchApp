//
//  FlickrResponse.swift
//  FlickrSearchApp
//
//  Created by Asaf Ahmed on 7/2/24.
//

import Foundation
struct FlickrResponse: Decodable {
    let items: [FlickrImage]
}

//
//  NetworkManager.swift
//  FlickrSearchApp
//
//  Created by Asaf Ahmed on 7/2/24.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()

    func fetchImages(query: String) -> AnyPublisher<[FlickrImage], Error> {
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(query)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> [FlickrImage] in
                let decoder = JSONDecoder()
                let response = try decoder.decode(FlickrResponse.self, from: data)
                return response.items
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

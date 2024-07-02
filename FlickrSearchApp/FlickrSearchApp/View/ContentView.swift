//
//  ContentView.swift
//  FlickrSearchApp
//
//  Created by Asaf Ahmed on 7/2/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        ForEach(viewModel.images) { image in
                            NavigationLink(destination: DetailView(image: image)) {
                                AsyncImage(url: URL(string: image.media.m)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var images: [FlickrImage] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.fetchImages(query: searchText)
            }
            .store(in: &cancellables)
    }

    func fetchImages(query: String) {
        guard !query.isEmpty else {
            images = []
            return
        }

        isLoading = true
        NetworkManager.shared.fetchImages(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching images: \(error)")
                }
            }, receiveValue: { [weak self] images in
                self?.images = images
            })
            .store(in: &cancellables)
    }
}

//
//  FlickrSearchAppTests.swift
//  FlickrSearchAppTests
//
//  Created by Asaf Ahmed on 7/2/24.
//

import XCTest
import Combine
@testable import FlickrSearchApp

final class FlickrSearchAppTests: XCTestCase {
    
    var viewModel: ContentViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        viewModel = ContentViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }

    func testFetchImages() throws {
        let expectation = XCTestExpectation(description: "Fetch images from Flickr API")

        viewModel.fetchImages(query: "porcupine")
        viewModel.$images
            .dropFirst()
            .sink { images in
                XCTAssertFalse(images.isEmpty, "Fetched images should not be empty")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0)
    }

    func testSearchTextDebounce() throws {
        let expectation = XCTestExpectation(description: "Debounced search text updates")
        viewModel.searchText = "porcupine"
        
        viewModel.$images
            .dropFirst() // Ignore the initial empty state
            .sink { images in
                XCTAssertFalse(images.isEmpty, "Fetched images should not be empty after search text change")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 10.0)
    }
}

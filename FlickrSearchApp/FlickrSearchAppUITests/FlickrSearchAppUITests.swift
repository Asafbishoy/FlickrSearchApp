//
//  FlickrSearchAppUITests.swift
//  FlickrSearchAppUITests
//
//  Created by Asaf Ahmed on 7/2/24.
//

import XCTest

final class FlickrSearchAppUITests: XCTestCase {
    
    override func setUpWithError() throws {

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    
    }

    func testSearchAndDisplayImages() throws {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists, "The search bar exists")
        searchBar.tap()
        searchBar.typeText("porcupine")

        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "count > 0"), object: app.collectionViews.cells)
        let result = XCTWaiter.wait(for: [expectation], timeout: 10)
        XCTAssertEqual(result, .completed, "Images loaded successfully")

    
        let cells = app.collectionViews.cells
        XCTAssertTrue(cells.count > 0, "The collection view is populated with images")

    
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.exists, "The first cell exists")
            firstCell.tap()
            
        
            let detailView = app.otherElements["DetailView"]
            XCTAssertTrue(detailView.exists, "The detail view is displayed")

            // Check for the image, title, description, author, and published date in the detail view
            let detailImage = detailView.images["DetailImage"]
            let title = detailView.staticTexts["Title"]
            let description = detailView.staticTexts["Description"]
            let author = detailView.staticTexts["Author"]
            let published = detailView.staticTexts["Published"]

            XCTAssertTrue(detailImage.exists, "The image is displayed in detail view")
            XCTAssertTrue(title.exists, "The title is displayed in detail view")
            XCTAssertTrue(description.exists, "The description is displayed in detail view")
            XCTAssertTrue(author.exists, "The author is displayed in detail view")
            XCTAssertTrue(published.exists, "The published date is displayed in detail view")
        }
    }
}

//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Ashutosh Singh on 03/03/25.
//

import XCTest
import Combine
@testable import MovieApp

final class MovieViewModelTests: XCTestCase {

    var viewModel: MovieViewModel!
    var apiServiceMock: APIServiceMock!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiServiceMock = APIServiceMock()
//        viewModel = MovieViewModel(apiService: apiServiceMock) // Inject Mock Service
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        apiServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test Fetch Movies (Success)
    func testFetchMovies_Success() {
        let expectation = XCTestExpectation(description: "Movies fetched successfully")
        
        // Mock movies
        let mockMovies = [
            Movie(id: 1, title: "Inception", overview: "A mind-bending thriller", posterPath: nil, backdropPath: nil, releaseDate: "2010-07-16", voteAverage: 8.8, voteCount: 1000),
            Movie(id: 2, title: "Interstellar", overview: "A journey beyond the stars", posterPath: nil, backdropPath: nil, releaseDate: "2014-11-07", voteAverage: 8.6, voteCount: 2000)
        ]
        
        apiServiceMock.mockMovies = mockMovies
        
        viewModel.$filteredMovies
            .dropFirst() // Ignore initial value
            .sink { movies in
                XCTAssertEqual(movies.count, 2, "Expected 2 movies but got \(movies.count)")
                XCTAssertEqual(movies.first?.title, "Inception")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchMovies()
        
        wait(for: [expectation], timeout: 3.0)
    }

    // MARK: - Test Fetch Movies (Failure)
    func testFetchMovies_Failure() {
        let expectation = XCTestExpectation(description: "API call fails")
        
        apiServiceMock.shouldReturnError = true
        
        viewModel.fetchMovies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.filteredMovies.isEmpty, "Movies should be empty on API failure")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

    // MARK: - Test Searching Movies
    func testSearchMovies() {
        let mockMovies = [
            Movie(id: 1, title: "Batman Begins", overview: "Dark Knight rises", posterPath: nil, backdropPath: nil, releaseDate: "2005-06-15", voteAverage: 8.2, voteCount: 900),
            Movie(id: 2, title: "The Dark Knight", overview: "Joker appears", posterPath: nil, backdropPath: nil, releaseDate: "2008-07-18", voteAverage: 9.0, voteCount: 1200)
        ]
        
//        viewModel.allMovies = mockMovies
        viewModel.searchMovies(with: "Batman")
        
        XCTAssertEqual(viewModel.filteredMovies.count, 1)
        XCTAssertEqual(viewModel.filteredMovies.first?.title, "Batman Begins")
    }

    func testSearchMovies_EmptyQuery() {
        let mockMovies = [
            Movie(id: 1, title: "Batman Begins", overview: "Dark Knight rises", posterPath: nil, backdropPath: nil, releaseDate: "2005-06-15", voteAverage: 8.2, voteCount: 900)
        ]
        
//        viewModel.allMovies = mockMovies
        viewModel.searchMovies(with: "")
        
        XCTAssertEqual(viewModel.filteredMovies.count, 1)
    }
}

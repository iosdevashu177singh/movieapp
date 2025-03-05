//
//  APIServiceMock.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 05/03/25.
//


import Foundation
import Combine

class APIServiceMock: APIServiceProtocol {
    
    var mockMovies: [Movie] = []
    var shouldReturnError = false
    
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            return Just(mockMovies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

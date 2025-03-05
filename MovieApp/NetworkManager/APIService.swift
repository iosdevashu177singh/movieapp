//
//  APIService.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//


import Foundation


import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    private let session: URLSession
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "9a7243213d79e4344f8f16ce3b6098cf"
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Fetch Popular Movies
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        let urlString = "\(baseURL)/discover/movie?sort_by=popularity.desc&api_key=\(apiKey)"
        
        return fetchData(from: urlString)
            .map { (response: MovieResponse) in response.results }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Generic Fetch Method
    private func fetchData<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                // Debug: Print raw JSON response
                if let jsonString = String(data: result.data, encoding: .utf8) {
                    print("API Response: \(jsonString)")
                }

                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                print("Decoding Error: \(error)")  // Print the decoding error
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}



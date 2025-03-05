//
//  MovieResponse.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//


import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    
    
    enum CodingKeys: String, CodingKey {
       
        case page = "page"
        case results = "results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case overview = "overview"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}



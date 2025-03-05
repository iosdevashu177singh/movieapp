//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//


import Foundation
import Combine

class MovieViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var allMovies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var isLoading: Bool = false

    var reloadCollectionView: (() -> Void)?

    func fetchMovies() {
        isLoading = true  

        APIService.shared.fetchPopularMovies()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] movies in
                self?.allMovies = movies
                self?.filteredMovies = movies
                self?.reloadCollectionView?()
            })
            .store(in: &cancellables)
    }

    func searchMovies(with query: String) {
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let filtered = query.isEmpty ? self.allMovies : self.allMovies.filter {
                $0.title.lowercased().contains(query.lowercased())
            }

            DispatchQueue.main.async {
                self.filteredMovies = filtered
                self.isLoading = false
                self.reloadCollectionView?()
            }
        }
    }
}


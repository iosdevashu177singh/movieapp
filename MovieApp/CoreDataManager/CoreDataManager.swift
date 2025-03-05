//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//


import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton instance

    private init() {}

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieApp") // Replace with your Core Data Model name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Movie to Favorites
    func saveMovieToFavorites(movie: Movie) {
        let favoriteMovie = FavoriteMovie(context: context)
        favoriteMovie.id = Int64(movie.id)
        favoriteMovie.title = movie.title
        favoriteMovie.overview = movie.overview
        favoriteMovie.posterPath = movie.posterPath
        favoriteMovie.voteAverage = Int64(movie.voteAverage)
//        favoriteMovie.popularity = movie.p ?? 0.0

        saveContext()
    }

    // MARK: - Fetch Favorite Movies
    func fetchFavoriteMovies() -> [FavoriteMovie] {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite movies: \(error)")
            return []
        }
    }

    // MARK: - Remove Movie from Favorites
    func removeMovieFromFavorites(movieID: Int) {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Failed to delete favorite movie: \(error)")
        }
    }

    // MARK: - Check if Movie is Favorite
    func isMovieFavorite(movieID: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check if movie is favorite: \(error)")
            return false
        }
    }

    // MARK: - Save Changes
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}

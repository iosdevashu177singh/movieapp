//
//  FavoriteMovieVC.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 04/03/25.
//

import UIKit

class FavoriteMovieVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
         var favoriteMovies: [FavoriteMovie] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            fetchFavorites()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchFavorites()
        }
        
        private func fetchFavorites() {
            favoriteMovies = CoreDataManager.shared.fetchFavoriteMovies()
            print(favoriteMovies.first?.voteAverage)
            tableView.reloadData()
        }
    }


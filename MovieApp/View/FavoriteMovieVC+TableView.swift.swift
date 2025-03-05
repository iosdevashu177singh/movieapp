//
//  FavoriteMovieVC+TableView.swift.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 04/03/25.
//



import UIKit

extension FavoriteMovieVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = favoriteMovies.count
        
        if count == 0 {
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath) as? FovouriteCell
        let favoriteMovie = favoriteMovies[indexPath.row]
        cell?.configure(with: favoriteMovie)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedMovie = favoriteMovies[indexPath.row]
//        
//        let detailVC = MovieDetailVC()
//        detailVC.movie = Movie(
//            id: Int(selectedMovie.id),
//            title: selectedMovie.title ?? "",
//            overview: selectedMovie.overview ?? "",
//            posterPath: selectedMovie.posterPath ?? "",
//            voteAverage: selectedMovie.voteAverage
//        )
//        
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 226
    }
}






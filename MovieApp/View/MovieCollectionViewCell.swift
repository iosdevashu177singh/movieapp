//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//


import UIKit
import SDWebImage
import Cosmos


class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var makeFovourteBtn: UIButton!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var moviewNameLbl: UILabel!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var imageView: UIImageView!
    private var movie: Movie?
    
    private var isFavourite: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        favouriteIcon.image = UIImage(systemName: "heart")
        favouriteIcon.tintColor = .gray
        
        makeFovourteBtn.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func favouriteButtonTapped() {
        guard let movie = movie else { return }

                let isFavorite = CoreDataManager.shared.isMovieFavorite(movieID: movie.id)

                if isFavorite {
                    CoreDataManager.shared.removeMovieFromFavorites(movieID: movie.id)
                } else {
                    CoreDataManager.shared.saveMovieToFavorites(movie: movie)
                }

                // Update UI after action
                updateFavoriteIcon(isFavorite: !isFavorite)
    }
    
    
    
    private func updateFavoriteIcon(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favouriteIcon.image = UIImage(systemName: imageName)
        favouriteIcon.tintColor = isFavorite ? .red : .gray

        }
    
    
    func configure(with items: Movie) {
        let fullImageURL = "https://image.tmdb.org/t/p/w500" + (items.posterPath ?? "")
        imageView.sd_setImage(with: URL(string: fullImageURL), placeholderImage: UIImage(named: "placeholder"))
        imageView.layer.cornerRadius = 10
        releaseDateLbl.text = items.releaseDate
        moviewNameLbl.text = items.title
        ratingStarView.rating = items.voteAverage
        
        self.movie = items
        
        // Check if movie is favorite and update UI
        let isFavorite = CoreDataManager.shared.isMovieFavorite(movieID: movie?.id ?? 0)
        updateFavoriteIcon(isFavorite: isFavorite)
        
        
        
        updateFavoriteIcon(isFavorite: isFavorite)
    }
    
    
}

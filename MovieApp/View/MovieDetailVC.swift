//
//  MovieDetailVC.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//



import UIKit
import Cosmos




class MovieDetailVC: UIViewController{
    
    
    @IBOutlet weak var smallMoviewImagePoster: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
     var movie: Movie?
    
    @IBOutlet weak var reviewStarView: CosmosView!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var popularityLbl: UILabel!
    
    
    @IBOutlet weak var backGroundView: GradientBackgroundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImageView.layer.cornerRadius = 70
            posterImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            posterImageView.layer.masksToBounds = true
        
        smallMoviewImagePoster.layer.cornerRadius = 10
        
        setupView()
        
       
        
    }
    
    func setupView() {
        guard let movie = movie else { return }
        
        // Assign Title
        titleLbl.text = movie.title
        
        // Assign Review Score & Count
        reviewStarView.rating = movie.voteAverage
        reviewLbl.text = "\(movie.voteAverage)"
        
        // Assign Popularity
//        popularityLbl.text = "Popularity: \(Int(movie.popularity ?? 0.0))"
        
        // Assign Description
        descriptionView.text = movie.overview
        
        // Load Images using SDWebImage
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie.posterPath {
            posterImageView.sd_setImage(with: URL(string: baseImageURL + posterPath), placeholderImage: UIImage(named: "placeholder"))
        }
        
        if let smallPosterPath = movie.posterPath {
            smallMoviewImagePoster.sd_setImage(with: URL(string: baseImageURL + smallPosterPath), placeholderImage: UIImage(named: "placeholder"))
        }
        
        // Apply Styling (Optional)
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        smallMoviewImagePoster.layer.cornerRadius = 5
        smallMoviewImagePoster.clipsToBounds = true
    }

    
}

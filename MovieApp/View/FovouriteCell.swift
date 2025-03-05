//
//  FovouriteCell.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 04/03/25.
//

import UIKit
import Cosmos

class FovouriteCell: UITableViewCell {

    @IBOutlet weak var moviewImageView: UIImageView!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var voteReviewLbl: UILabel!
    @IBOutlet weak var titlelBL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with movie: FavoriteMovie) {
            titlelBL.text = movie.title
            popularityLbl.text = "Popularity: \(movie.popularity)"
        voteReviewLbl.text = "\(movie.voteAverage)"
            
        ratingView.rating = Double(movie.voteAverage)
        
        
        let fullImageURL = "https://image.tmdb.org/t/p/w500" + (movie.posterPath ?? "")
        moviewImageView.sd_setImage(with: URL(string: fullImageURL), placeholderImage: UIImage(named: "placeholder"))
        moviewImageView.layer.cornerRadius = 10
        }

}

//
//  MovieCell.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import Kingfisher

final class MovieCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak fileprivate var posterImageView: UIImageView!
    @IBOutlet weak fileprivate var movieNameLabel: UILabel!
    @IBOutlet weak fileprivate var releaseDateLabel: UILabel!
    @IBOutlet weak fileprivate var overViewTextView: UITextView!
    @IBOutlet weak fileprivate var containMovieView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Setup shadow for cell
        self.containMovieView.layer.applySketchShadow(color: UIColor.shadowColor, alpha: 0.2, x: 0.5, y: 2, blur: 6, spread: 0)
        self.containMovieView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// Setup display MovieCell
    ///
    /// - Parameter model: Movie model
    func setupMovieCellWithModel(model: Movie) {
        
        movieNameLabel.text = model.title
        releaseDateLabel.text = model.releaseDate.convertDateStringToCareemFormat()
        overViewTextView.text = model.overview.count > 0 ? model.overview : "No description available"
        
        // Incase all image of movie is null
        let imagePath = model.posterPath ?? model.backdropPath
        if let imagePath = imagePath {
            let imageFullURL = Helper.getFullImageURL(imagePath: imagePath, type: .w185)
            if let url = URL(string: imageFullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                posterImageView.kf.setImage(with: url,
                                            placeholder: UIImage(named: "movie_placeholder"),
                                            options: [.transition(ImageTransition.fade(0.2))])
            }
        }
    }
    
}

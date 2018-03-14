//
//  SuggestionCell.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

final class SuggestionCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var suggestionNameLabel: UILabel!
    @IBOutlet weak private var resultsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// Setup display cell
    ///
    /// - Parameter model: suggestion model
    func setupCellWithSuggestion(model: Suggestion) {
        suggestionNameLabel.text = model.name
        resultsLabel.text = "\(model.totalResult) result" + ((Int(model.totalResult) ?? 0) > 1 ? "s" : "")
    }
    
}

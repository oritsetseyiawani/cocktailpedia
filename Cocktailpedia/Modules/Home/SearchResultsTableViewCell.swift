//
//  SearchResultsTableViewCell.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    @IBOutlet var cocktailImage: UIImageView!
    @IBOutlet var cocktailNameLabel: UILabel!
    static let identifier = String(describing: SearchResultsTableViewCell.self)
}

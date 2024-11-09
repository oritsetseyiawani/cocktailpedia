//
//  FavoritesTableViewCell.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    @IBOutlet var cocktailImage: UIImageView!
    @IBOutlet var cocktailNameLabel: UILabel!
    static let identifier = String(describing: FavoritesTableViewCell.self)
}

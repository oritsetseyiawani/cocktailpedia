//
//  FavoritesTableViewCell.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    static let identifier = String(describing: FavoritesTableViewCell.self)
}

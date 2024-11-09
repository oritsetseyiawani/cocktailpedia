//
//  CocktailDetailsTableViewCell.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit

class CocktailDetailsTableViewCell: UITableViewCell {
    @IBOutlet var fieldNameLabel: UILabel!
    @IBOutlet var fieldValueLabel: UILabel!
    static let identifier = String(describing: CocktailDetailsTableViewCell.self)
}

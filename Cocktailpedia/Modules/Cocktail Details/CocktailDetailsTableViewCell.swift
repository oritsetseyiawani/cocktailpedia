//
//  CocktailDetailsTableViewCell.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit

class CocktailDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldValueLabel: UILabel!
    static let identifier = String(describing: CocktailDetailsTableViewCell.self)
}

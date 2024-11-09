//
//  CocktailDetailsViewController.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit

class CocktailDetailsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cocktailImage: UIImageView!
    @IBOutlet var cocktailName: UILabel!

    @IBOutlet var favoriteButton: UIButton!

    var cocktailDetailsViewModel: CocktailDetailsViewModelType = CocktailDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        switch cocktailDetailsViewModel.segueStartPoint {
        case .homeViewController:
            cocktailName.text = cocktailDetailsViewModel.selectedCocktail["strDrink"] as? String
            cocktailImage.kf.setImage(with: URL(string: (cocktailDetailsViewModel.selectedCocktail["strDrinkThumb"] ?? "") ?? ""))
            cocktailDetailsViewModel.populateTableView()
        case .favoritesViewController:
            cocktailDetailsViewModel.populateTableView()
            cocktailName.text = cocktailDetailsViewModel.selectedCocktail.keys.first
            cocktailImage.kf.setImage(with: URL(string: cocktailDetailsViewModel.favoriteCocktails[cocktailDetailsViewModel.getCocktailIndex()].imageUrl))
        case .none:
            print("Nothing for now")
        }
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        checkIsCocktailFavorited()
        tableView.reloadData()
    }

    func checkIsCocktailFavorited() {
        switch cocktailDetailsViewModel.shouldUpdateFavoritesIcon(realmObject: PersistenceManager.realm) {
        case true:
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        case false:
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}

// MARK: - TABLEVIEW DATA SOURCE

extension CocktailDetailsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cocktailDetailsViewModel.tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CocktailDetailsTableViewCell.identifier) as! CocktailDetailsTableViewCell
        if cocktailDetailsViewModel.segueStartPoint == .favoritesViewController {
            cell.fieldNameLabel.text = cocktailDetailsViewModel.tableViewData[indexPath.row].fieldName
            cell.fieldValueLabel.text = cocktailDetailsViewModel.tableViewData[indexPath.row].fieldValue
            return cell
        } else {
            cell.fieldNameLabel.text = cocktailDetailsViewModel.tableViewData[indexPath.row].fieldName
            cell.fieldValueLabel.text = cocktailDetailsViewModel.tableViewData[indexPath.row].fieldValue
            return cell
        }
    }

    // MARK: - Favorite Button

    @IBAction func didTapFavoriteButton(_: Any) {
        if favoriteButton.currentImage == UIImage(systemName: "star.fill") {
            let alertController = UIAlertController(title: "⚠️", message: Constants.removeFromFavoritesMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in self.removeFromFavorites() }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            let alertController = UIAlertController(title: "⭐️", message: Constants.addedToFavoritesMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in self.addToFavorites() }))
            present(alertController, animated: true, completion: nil)
        }
    }

    func removeFromFavorites() {
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        cocktailDetailsViewModel.removeFromFavorites(realmObject: PersistenceManager.realm)
    }

    func addToFavorites() {
        cocktailDetailsViewModel.saveToFavorites(realmObject: PersistenceManager.realm)
    }
}

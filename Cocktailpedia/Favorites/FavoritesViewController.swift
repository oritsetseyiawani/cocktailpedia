//
//  FavoritesViewController.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoritesViewModel: FavoritesViewModelType = FavoritesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesViewModel.retrieveSavedCocktails()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoritesViewModel.retrieveSavedCocktails()
        tableView.reloadData()

    }
}

//MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesViewModel.favoriteCocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier) as! FavoritesTableViewCell
        cell.cocktailNameLabel.text = favoritesViewModel.favoriteCocktails[indexPath.row].cocktailName.capitalizingFirstLetter()
        let url = URL(string: favoritesViewModel.favoriteCocktails[indexPath.row].imageUrl )
        cell.cocktailImage.kf.setImage(with: url)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        favoritesViewModel.selectedCocktail = ["\( favoritesViewModel.favoriteCocktails[indexPath.row].cocktailName)": "\(favoritesViewModel.favoriteCocktails[indexPath.row].ingredients)"]
        performSegue(withIdentifier: Constants.favoritesToCocktailDetailViewSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CocktailDetailsViewController
        destination.cocktailDetailsViewModel.selectedCocktail = favoritesViewModel.selectedCocktail
        destination.cocktailDetailsViewModel.segueStartPoint = .favoritesViewController
        destination.cocktailDetailsViewModel.favoriteCocktails = favoritesViewModel.favoriteCocktails
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] _, _, completion in
            let breedName = self?.favoritesViewModel.favoriteCocktails[indexPath.row].cocktailName
            self?.favoritesViewModel.removeFromFavorites(realmObject: PersistenceManager.realm, cocktailName: breedName ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let shareAction = UIContextualAction(style: .normal, title: nil) {[weak self] _, _, completion in
            let pasteboard = UIPasteboard.general
            
            pasteboard.string = "Hey! Download Cocktailpedia app to learn about \(self?.favoritesViewModel.favoriteCocktails[indexPath.row].cocktailName ?? "Cocktails")"
            completion(true)
        }
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        let config = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}

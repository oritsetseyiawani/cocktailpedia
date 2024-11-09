//
//  HomeViewController.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import Combine
import Kingfisher
import UIKit

class HomeViewController: UIViewController {
    var homeViewModel: HomeViewModelType = HomeViewModel(networkManager: NetworkManager())
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return homeViewModel.drinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier) as! SearchResultsTableViewCell

        if homeViewModel.drinks.count > 0 {
            let cocktailName = homeViewModel.drinks[indexPath.row]["strDrink"] ?? ""
            cell.cocktailNameLabel.text = cocktailName?.capitalizingFirstLetter()
            cell.cocktailImage.kf.setImage(with: URL(string: (homeViewModel.drinks[indexPath.row]["strDrinkThumb"] ?? "") ?? ""))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        homeViewModel.selectedCocktail = homeViewModel.drinks[indexPath.row]
        performSegue(withIdentifier: Constants.homeViewToCocktailDetailViewSegue, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        let destination = segue.destination as! CocktailDetailsViewController
        destination.cocktailDetailsViewModel.selectedCocktail = homeViewModel.selectedCocktail
        destination.cocktailDetailsViewModel.segueStartPoint = .homeViewController
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cocktailName = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        searchBar.text = ""
        homeViewModel.informNetworkManagerToPerformRequest(textEntered: cocktailName)
        homeViewModel.statePublisher.receive(on: RunLoop.main).sink { _ in
        } receiveValue: { [weak self] state in

            switch state {
            default:
                self?.tableView.reloadData()
            }
        }.store(in: &homeViewModel.observers)
    }
}

//
//  ViewController.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn 
//

import UIKit
import Combine
import Kingfisher

class HomeViewController: UIViewController {
    var homeViewModel: HomeViewModelType = HomeViewModel(networkManager: NetworkManager())
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier) as! SearchResultsTableViewCell
        
        if (homeViewModel.drinks.count > 0) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        homeViewModel.statePublisher.receive(on: RunLoop.main).sink { state in
        } receiveValue: { [weak self] state in
            
            switch (state){
            default:
                self?.tableView.reloadData()
            }
        }.store(in: &homeViewModel.observers)
    }
}


//
//  FavoritesViewModel.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import Foundation
import RealmSwift

protocol FavoritesViewModelType {
    var cocktails: [String: [String]] { get }
    var selectedCocktail: [String: String?] { get set }
    var cocktailImage: String { get set }
    func retrieveSavedCocktails()
    var favoriteCocktails: [FavoriteCocktails] { get }
    func removeFromFavorites(realmObject: Realm, cocktailName: String)
}

class FavoritesViewModel: FavoritesViewModelType {
    var cocktails: [String: [String]] = [:]
    var selectedCocktail: [String: String?] = [:]
    var cocktailImage: String = ""
    var favoriteCocktails: [FavoriteCocktails] = []

    func retrieveSavedCocktails() {
        favoriteCocktails = []
        let realm = PersistenceManager.realm
        let cocktails = realm.objects(CocktailRealm.self)
        for cocktail in cocktails {
            let singleCocktail = FavoriteCocktails(cocktailName: cocktail.cocktailName, imageUrl: cocktail.imageUrl, ingredients: cocktail.ingredients)
            favoriteCocktails.append(singleCocktail)
        }
    }

    func removeFromFavorites(realmObject: Realm, cocktailName: String) {
        let realm = realmObject
        do {
            try realm.write {
                // Access all cocktails in the realm
                let cocktails = realm.objects(CocktailRealm.self).where {
                    $0.cocktailName == cocktailName

                    //                    $0.cocktailName == cocktailName.capitalizingFirstLetter()
                }
                realm.delete(cocktails)
                retrieveSavedCocktails()
            }
        } catch {
            print("Failed to delete from database")
        }
    }
}

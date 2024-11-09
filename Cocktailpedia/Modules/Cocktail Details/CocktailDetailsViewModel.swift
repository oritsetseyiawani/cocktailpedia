//
//  CocktailDetailsViewModel.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import Foundation
import RealmSwift

protocol CocktailDetailsViewModelType {
    var selectedCocktail: [String: String?] { get set }
    var tableViewData: [CocktailDetails] { get }
    func populateTableView()
    var favoriteCocktails: [FavoriteCocktails] { get set }
    var segueStartPoint: previousController { get set }

    //

    func saveToFavorites(realmObject: Realm)
    func removeFromFavorites(realmObject: Realm)
    func shouldUpdateFavoritesIcon(realmObject: Realm) -> Bool
    var cocktailName: String { get set }
    func getCocktailIndex() -> Int
}

class CocktailDetailsViewModel: CocktailDetailsViewModelType {
    var ingredients: String = ""
    var instructions = ""
    var tableViewData: [CocktailDetails] = []
    var selectedCocktail: [String: String?] = [:]
    var favoriteCocktails: [FavoriteCocktails] = []
    var segueStartPoint: previousController = .none
    var cocktailName = ""

    func populateTableView() {
        for (dictionaryNameFromApiCall, dictionaryValueFromApiCall) in selectedCocktail {
            if dictionaryValueFromApiCall != nil && dictionaryNameFromApiCall.starts(with: "strIngredient") {
                guard let dictionaryValueFromApiCall = dictionaryValueFromApiCall else {
                    return
                }
                if dictionaryNameFromApiCall.starts(with: "strIngredient") && !ingredients.contains("\(dictionaryValueFromApiCall)") {
                    ingredients.append("\(dictionaryValueFromApiCall), ")
                    cocktailName = (selectedCocktail["strDrink"] ?? "") ?? ""
                }
                instructions = selectedCocktail["strInstructions"] as? String ?? ""
            } else if segueStartPoint == .favoritesViewController {
                let realm = PersistenceManager.realm
                let cocktails = realm.objects(CocktailRealm.self)
                let isFavorited = cocktails.where { $0.cocktailName.contains(selectedCocktail.first?.key ?? "") }
                ingredients = isFavorited.first?.ingredients ?? ""
                instructions = isFavorited.first?.instructions ?? ""
            }
        }
        let row1 = CocktailDetails(fieldName: "Ingredients:", fieldValue: String(ingredients))
        let row2 = CocktailDetails(fieldName: "Instructions:", fieldValue: instructions.capitalizingFirstLetter())
        tableViewData = [row1, row2]
    }

    func saveToFavorites(realmObject: Realm) {
        let realm = realmObject
        do {
            try realm.write {
                // Access all cocktails in the realm
                let cocktails = realm.objects(CocktailRealm.self).where {
                    $0.cocktailName == cocktailName
                }
                let isSavedInFavorites = cocktails.where {
                    $0.cocktailName.contains(cocktailName)
                }
                switch isSavedInFavorites.isEmpty {
                case true:
                    let cocktail = CocktailRealm()
                    cocktail.cocktailName = selectedCocktail["strDrink"] as? String ?? ""
                    cocktail.imageUrl = (selectedCocktail["strDrinkThumb"] ?? "") ?? ""
                    cocktail.ingredients = ingredients
                    cocktail.instructions = selectedCocktail["strInstructions"] as? String ?? ""
                    realm.add(cocktail)
                case false:
                    print("Already exists")
                }
            }
        } catch {
            print("Failed to save")
        }
    }

    func removeFromFavorites(realmObject: Realm) {
        let realm = realmObject
        do {
            try realm.write {
                // Access all cocktails in the realm
                let cocktails = realm.objects(CocktailRealm.self).where {
                    $0.cocktailName.contains(cocktailName) || $0.cocktailName == selectedCocktail.keys.first ?? ""
                }
                realm.delete(cocktails)
            }
        } catch {
            print("Failed to delete from database")
        }
    }

    func shouldUpdateFavoritesIcon(realmObject: Realm) -> Bool {
        let realm = realmObject
        let cocktails = realm.objects(CocktailRealm.self)
        let isFavorited = cocktails.where { $0.cocktailName.contains(cocktailName) || $0.cocktailName == selectedCocktail.keys.first ?? "" }
        switch isFavorited.isEmpty {
        case true:
            return false
        case false:
            return true
        }
    }

    func getCocktailIndex() -> Int {
        let value = favoriteCocktails.firstIndex { $0.cocktailName == selectedCocktail.keys.first }
        return value ?? 0
    }
}

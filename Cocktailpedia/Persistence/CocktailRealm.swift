//
//  CocktailRealm.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn on 02/11/2022.
//

import Foundation
import RealmSwift

class CocktailRealm: Object {
    @Persisted var cocktailName: String
    @Persisted var imageUrl: String
    @Persisted var ingredients: String
    @Persisted var instructions: String
}

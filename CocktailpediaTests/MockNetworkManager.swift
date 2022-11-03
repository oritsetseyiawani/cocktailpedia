//
//  MockNetworkManager.swift
//  CocktailpediaTests
//
//  Created by Awani Melvyn on 16/09/2022.
//

import Foundation
import Combine

@testable import Cocktailpedia

class MockNetworkManager: Networkable {
    func makeApiCall(textEntered: String) -> Future<Cocktail, Error> {
        
        return Future { result in
            
            if let path = Bundle.main.path(forResource: "cocktails", ofType: "json") {
                
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)

                    let parsedData = try JSONDecoder().decode(Cocktail.self, from: data)
                    result(.success(parsedData))
                    
                } catch  {
                    print("Error decoding file")
                    result(.failure(error))
                }
                
            }
            
        }
        
    }
    
    
    
}

//
//  NetworkManager.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn
//

import Foundation
import Combine

protocol Networkable {
    func makeApiCall(textEntered: String) -> Future<Cocktail,Error>
}

class NetworkManager: Networkable {
    func makeApiCall(textEntered: String) -> Future<Cocktail,Error>{
        return Future { result in
            let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(textEntered)"
            guard let url: URL = URL(string: urlString) else  {
                return
            }
            let datatask = URLSession.shared
            datatask.dataTask(with: url) { data, _, error in
                if (error == nil){
                    guard let data = data else {
                        return
                    }
                    do {
                        let parsedData = try JSONDecoder().decode(Cocktail.self, from: data)
                        result(.success(parsedData))
                    } catch  {
                        print("Error decoding file")
                        result(.failure(error))
                    }
                }
            }.resume()
        }
    }
}

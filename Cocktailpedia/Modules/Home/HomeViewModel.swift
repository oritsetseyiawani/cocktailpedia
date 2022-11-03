//
//  HomeViewModel.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn 
//

import Foundation
import Combine


protocol HomeViewModelType {
    var drinks:[[String : String?]]  {get}
    var observers: [AnyCancellable] {get set}
    var selectedCocktail: [String : String?] {get set}
    var statePublisher: Published<State>.Publisher { get }
    func informNetworkManagerToPerformRequest(textEntered: String)
}

class HomeViewModel: HomeViewModelType {
    
    init(networkManager: Networkable){
        self.networkManager = networkManager
    }
    
    var networkManager: Networkable
    var observers: [AnyCancellable] = []
    var drinks:[[String : String?]]   = []
    var selectedCocktail: [String : String?] = [:]
    @Published  var state: State = .none
    var statePublisher: Published<State>.Publisher { $state }
    
    public func informNetworkManagerToPerformRequest(textEntered: String) {
        networkManager.makeApiCall(textEntered: textEntered).receive(on: DispatchQueue.main).sink { error in
            switch (error){
            case .failure:
                print("Failed")
                self.state = .fail
                self.drinks = []
            case .finished:
                print("Finished")
            }
        } receiveValue: { [weak self] cocktail in
            self?.drinks = cocktail.drinks
            for (yes, pas) in cocktail.drinks[0] {
                if (pas != nil ){
                    guard let pas = pas else{
                        return
                    }
                    if yes.starts(with: "strIngredient"){
                        print ("\(yes) : \(String(describing: pas))")
                    }
                }
                self?.state = .pass
            }
        }.store(in: &observers)
    }
}

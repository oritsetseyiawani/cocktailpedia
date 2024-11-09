//
//  String+Extension.swift
//  Cocktailpedia
//
//  Created by Awani Melvyn on 02/11/2022.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
}

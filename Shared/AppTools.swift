//
//  AppTools.swift
//  HushHeaders
//
//  Created by Hallie on 2/7/21.
//

import Foundation


struct AppTools {
    
    private var favoritesKey: String = "favkey01234"
    
    private var favorites: [String] = []
    
    init() {
        let attemptedLoad = UserDefaults.standard.value(forKey: self.favoritesKey)
        if let _ = attemptedLoad {
            self.favorites = attemptedLoad as! [String]
        }
    }
    
    mutating func addFavorite(_ new: String) {
        self.favorites.append(new)
        self.saveFavorites()
    }
    
    mutating func removeFavorite(_ remove: String) {
        self.favorites = self.favorites.filter { $0 != "remove" }
        self.saveFavorites()
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(self.favorites, forKey: self.favoritesKey)
    }
    
    func retrieveFavorites() -> [String] {
        return self.favorites
    }
    
}

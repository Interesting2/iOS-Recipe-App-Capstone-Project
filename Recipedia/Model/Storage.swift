//
//  Storage.swift
//  Recipedia
//
//  Created by Lei Io Tou on 11/10/2022.
//

import Foundation

class Storage {
    
    private let defaults = UserDefaults.standard
    private var saveDict = [String: Int]()
//    private var planToCook  = [""]
//    private var favourites = [""]
    
    
    public func resetSave() {
        defaults.removeObject(forKey: "savedRecipes")
    }
    
    public func resetBlacklist() {
        defaults.removeObject(forKey: "blacklistedRecipes")
    }
    
    /* Blacklist local storage functions */
    
    public func blacklist(recipeName: String) {
//        defaults.removeObject(forKey: "blacklistedRecipes")
        print("Blacklisting recipes")
        var blacklistedRecipesDefaults = defaults.array(forKey: "blacklistedRecipes") as? [String] ?? []
        if (!blacklistedRecipesDefaults.contains(recipeName)) {
//            print("blacklisted recipe already exist")
            blacklistedRecipesDefaults.append(recipeName)
            defaults.set(blacklistedRecipesDefaults, forKey: "blacklistedRecipes")

        }
        print(blacklistedRecipesDefaults)
       
    }
    
    public func retrieveBlacklist() -> [String] {
        return defaults.array(forKey: "blacklistedRecipes") as? [String] ?? []
    }
    
    
    
    /* Save Page local storage functions */
    public func save(category: Int, recipeName: String) -> Void {
//        defaults.removeObject(forKey: "savedRecipes")
        print("Saving recipes")
        
//        var savedRecipes: [[String: Any]] = []
//        UserDefaults.standard.set([Int](), forKey: "nums")
        var savedRecipesDefaults = defaults.array(forKey: "savedRecipes") as? [[String: Any]] ?? []
        let pair = [recipeName: category]
        
        var isExist = false;
        for recipe in savedRecipesDefaults.indices {
            if (Array(savedRecipesDefaults[recipe].keys)[0] == recipeName) {
                // key already exist
                savedRecipesDefaults[recipe][recipeName] = category
                isExist = true
            }
        }
        if (!isExist) {
            savedRecipesDefaults.append(pair)
        }

        defaults.set(savedRecipesDefaults, forKey: "savedRecipes")
        print(savedRecipesDefaults)
        
//        print(defaults.dictionaryRepresentation())
        
//        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            if (key == "savedRecipes") {
//                print("Printing key values")
//                print(key)
//                print(value)
//                print("\(key) = \(value) \n")
//                print("Done printing key values")
//            }
//
//
//
//        }
//        print("Keys")
//        print(defaults.dictionaryRepresentation().keys)
//        print("Values")
//        print(defaults.dictionaryRepresentation().values)
        print("Done saving")
    }
     
    public func unsave(recipeName: String){
        print("Unsaving recipe")
        if let savedRecipes = UserDefaults.standard.array(forKey: "savedRecipes") as? [[String: Any]] {
            print(savedRecipes)  // [[price: 19.99, qty: 1, name: A], [price: 4.99, qty: 2, name: B]]"
            for recipe in savedRecipes {
//                print(recipe["name"]  as! String)    // A, B
//                print(item["price"] as! Double)    // 19.99, 4.99
//                print(item["qty"]   as! Int)       // 1, 2
                let item = recipe.first!
                let (recipeNameDefault, recipeCategory) = item
                if (recipeNameDefault == recipeName) {
                    print(recipeNameDefault, recipeCategory)
//                    defaults.removeObject(forKey: recipeName)
                    let filteredSave = savedRecipes.filter{ Array($0.keys)[0] != recipeName }
                    print("Final savedRecipes after unsaving")
                    print(filteredSave)
                    defaults.set(filteredSave, forKey: "savedRecipes")
                    break
                }
//                print(recipeName, recipeCategory)
            }
        }
        print("Done unsave")
        
    }
    
    public func retrieveAll() -> [[String: Any]] {
        print("Retrieving recipes")
        if let savedRecipes = UserDefaults.standard.array(forKey: "savedRecipes") as? [[String: Any]] {
            print(savedRecipes)  // [[price: 19.99, qty: 1, name: A], [price: 4.99, qty: 2, name: B]]"
            for recipe in savedRecipes {
//                print(recipe["name"]  as! String)    // A, B
//                print(item["price"] as! Double)    // 19.99, 4.99
//                print(item["qty"]   as! Int)       // 1, 2
                let item = recipe.first!
                let (recipeName, recipeCategory) = item
                print(recipeName, recipeCategory)
                
            }
//
//            let filteredCategory = savedRecipes.filter{ $0.values.first! as! Int == category }
//            print("Filtered Recipe by category:", category)
//            print(filteredCategory)
//            print("Done retrieving")
//            return filteredCategory
            return savedRecipes
        }
        
        print("Error retrieving save recipes")
        return [[String: Any]]()
    }

    class var shared: Storage {
        struct Static {
            static let instance = Storage()

        }
        return Static.instance
    }
}

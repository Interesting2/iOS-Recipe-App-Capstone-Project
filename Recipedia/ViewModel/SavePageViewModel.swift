//
//  DetailPageViewModel.swift
//  Recipedia
//
//  Created by Justin on 23/8/2022.
//

import Foundation
import Firebase

class SavePageViewModel: ObservableObject {
    @Published private var savedRecipes = [RecipeDetail]()
    @Published var savedCategoryRecipes = [RecipeDetail]()
    
    @Published var show = false
//    @Published var blacklist : [String]
    
//    @Published var selectedRecipe = RecipeDetail(fullImagePath: "", thumbnailPath: "", name: "", description: "", methodSummary: "", likes: 99, kcals: "", ratings: 10, isSaved: 0, isLiked: false, ingredients: [], nutritions: [], method: [], id: "")
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("Recipes").getDocuments { snapshot, error in
            // check for errors
            if error == nil {
                // No errors
                print("no error")
                if let snapshot = snapshot {
                    //Update the list in main thread
                    DispatchQueue.main.async {
                        // get all the documents and create Recipe list
                        print("Save page view model")
                        
                        self.savedRecipes = snapshot.documents.map { recipeInfo in
//                            print(recipeInfo["name"])
                            return RecipeDetail(name: recipeInfo["name"] as? String ?? "",
                                       methodSummary: recipeInfo["methodSummary"] as? String ?? "",
                                       description: recipeInfo["description"] as? String ?? "",
                                       fullImagePath: recipeInfo["fullImagePath"] as? String ?? "",
                                       thumbnailPath: recipeInfo["thumbnailPath"] as? String ?? "",
                                       ratings: recipeInfo["ratings"] as? Double ?? 0,
                                       isSaved: recipeInfo["isSaved"] as? Int ?? 0,
                                       numberOfRatings: recipeInfo["numberOfRatings"] as? Int ?? 0,
                                       likes: recipeInfo["likes"] as? Int ?? 0,
                                       calorie: recipeInfo["calorie"] as? Int ?? 0,
                                       protein: recipeInfo["protein"] as? Double ?? 0,
                                       fat: recipeInfo["fat"] as? Double ?? 0,
                                       sugar: recipeInfo["sugar"] as? Double ?? 0,
                                       ingredient: recipeInfo["ingredient"] as? [String] ?? [""],
                                       ingredientSummary: recipeInfo["ingredientSummary"] as? [String] ?? [""],
                                       method: recipeInfo["method"] as? [String] ?? [""],
                                       id: recipeInfo.documentID)
                            
                            
                        }
                    }
                    
                }
            } else {
                // Handle the error
                print("ERRORRRRRR")
            }
            
        }
        print("GOT DATA\n\n\n")
        print("Num of recipes: " + String(savedRecipes.count))
        for recipe in savedRecipes {
            print(recipe.name)
        }
    }
    
    func getSavedRecipes() {
        let blacklist = Storage.shared.retrieveBlacklist()
        let savedCategory = Storage.shared.retrieveAll()
        var tempSaved = [RecipeDetail]()
        for index in 0..<self.savedRecipes.count {
//            if (savedCategory.contains{ Array($0.keys)[0] == self.savedRecipes[index].name }) {
//                self.savedRecipes[index].isSaved = category
//                tempSaved.append(self.savedRecipes[index])
//            }
            let recipeName = self.savedRecipes[index].name
            if (blacklist.contains(recipeName)) {
                print("Blacklisted recipe: " + recipeName + "\nContinue...")
                continue
            }
            if let recipe = savedCategory.firstIndex(where: { Array($0.keys)[0] == recipeName}) {
                let tempRecipe = savedCategory[recipe]
                print("Temp Recipe")
                print(tempRecipe)
                self.savedRecipes[index].isSaved = tempRecipe[recipeName] as! Int
//                print(self.savedRecipes[index].isSaved)
                tempSaved.append(self.savedRecipes[index])
            }
        }
        
        self.savedCategoryRecipes = tempSaved
//        return self.savedCategoryRecipes
//        return self.savedCategoryRecipes
    }
    
    func getRecipes() -> [RecipeDetail] {
//        blacklistRecipes = Storage.shared.retrieveBlacklist() // update blacklist
        return self.savedCategoryRecipes
    }
    
    func setBlacklist(blacklist_: [String]) {
//        blacklist = blacklist_
    }
    
    

}

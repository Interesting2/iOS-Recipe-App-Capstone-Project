//
//  DetailPageViewModel.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import Foundation
import Firebase

class DetailPageViewModel: ObservableObject {
    @Published var selectedRecipe = RecipeDetail(name: "", methodSummary: "", description: "", fullImagePath: "", thumbnailPath: "", ratings: 99, isSaved: 0, numberOfRatings: 1, likes: 10, calorie: 10, protein: 10, fat: 10, sugar: 10, ingredient: [], ingredientSummary: [], method: [], id: "")
    @Published var show = false
    @Published var HomepageList = [RecipeDetail]()
    @Published var HomepageList1 = [RecipeDetail]()
    @Published var HomepageList2 = [RecipeDetail]()
    
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
                        self.HomepageList = snapshot.documents.map { recipeInfo in 
                            
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
                        self.HomepageList1 = self.HomepageList.sorted(by: { $0.likes > $1.likes })
                        self.HomepageList2 = self.HomepageList.sorted(by: { $0.ratings > $1.ratings})
                    }
                    
                }
            } else {
                // Handle the error
            }
            
        }
    }
}

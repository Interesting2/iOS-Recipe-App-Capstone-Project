//
//  SearchPageModel.swift
//  Recipedia
//
//  Created by Andrew Hou on 29/8/2022.
//

import Foundation

struct searchPage{
    var totalrecipes = [""]
    var searchText:String
    var orderChoice:Int
    var calorieChoice:Int
    var methodChoice:Int
    var functionChoice:Int
    var searchBarSize:Double
    
    var searchIngredients = [""]
    //var searchIngredients:[String] = []
    var dislikeIngredients = [""]
    
    var allIngredients = [""]
    
    var inputIngredient:String
    
    
    init(){
        searchText = ""
        orderChoice = 0
        calorieChoice = 0
        methodChoice = 0
        functionChoice = 0
        searchBarSize = 160.0
        inputIngredient = ""
        dislikeIngredients.remove(at: 0)
        searchIngredients.remove(at: 0)
        allIngredients.remove(at: 0)
    }
    
    
    mutating func delete(at offsets: IndexSet) {
        searchIngredients.remove(atOffsets: offsets)
    }

    mutating func deleteDislike(at offsets: IndexSet) {
        dislikeIngredients.remove(atOffsets: offsets)
    }

    mutating func add(ingredient:String){
        searchIngredients.append(ingredient)
    }

    mutating func addDislike(ingredient:String){
        dislikeIngredients.append(ingredient)
    }
    
    mutating func addTotalRecipes(ingredient:String){
        totalrecipes.append(ingredient)
    }
    
}

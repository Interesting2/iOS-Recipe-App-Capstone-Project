//
//  SearchPageViewModel.swift
//  Recipedia
//
//  Created by Andrew Hou on 29/8/2022.
//

import SwiftUI
import Firebase

class getSearchPage: ObservableObject{
    @Published private(set) var model: searchPage = searchPage()
    
    //let totalIngredients = ["almond cak ", "carrot", "tomato", "potato"]
    @Published var searchText:String
    @Published var orderChoice:Int
    @Published var calorieChoice:Int
    @Published var methodChoice:Int
    @Published var functionChoice:Int
    @Published var inputIngredient:String
        
    @Published var selectedRecipe = RecipeDetail(name: "", methodSummary: "", description: "", fullImagePath: "", thumbnailPath: "", ratings: 99, isSaved: 0, numberOfRatings: 1, likes: 10, calorie: 10, protein: 10, fat: 10, sugar: 10, ingredient: [], ingredientSummary: [], method: [], id: "")
    var oldIngredientNumber:Int = 0
    
    @Published var searchByIngredientResult = [RecipeDetail]()
    @Published var searchByIngredientResult1 = [RecipeDetail]()
    @Published var searchByIngredientResult2 = [RecipeDetail]()
    @Published var searchByIngredientResult3 = [RecipeDetail]()
    
    
    init(){
        searchText = ""
        orderChoice = 0
        calorieChoice = 0
        methodChoice = 0
        functionChoice = 0
        inputIngredient = ""
        getAllRecipe()
        getAllIngredients()
    }
    
    func updateAllChoice(){
        model.searchText = searchText
        model.orderChoice = orderChoice
        model.calorieChoice = calorieChoice
        model.methodChoice = methodChoice
        model.functionChoice = functionChoice
    }
    
    var searchRecipiesResults: [String]{
        if searchText.isEmpty {
            //searchBarSize = 160.0
            return []
        } else {
            //searchBarSize = 870.0
            //print(searchText)
            return model.totalrecipes.filter {
                $0.range(of: searchText.lowercased(), options: .caseInsensitive) != nil}
        }
    }
    
    var searchRecipesDetail:[RecipeDetail]{
        var list = [RecipeDetail]()
        for name in searchRecipiesResults{
            let db = Firestore.firestore()
            
            db.collection("Recipes").whereField("name", isEqualTo: name)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            list.append(RecipeDetail(name: document.data()["name"] as? String ?? "",
                                                               methodSummary: document.data()["methodSummary"] as? String ?? "",
                                                               description: document.data()["description"] as? String ?? "",
                                                               fullImagePath: document.data()["fullImagePath"] as? String ?? "",
                                                               thumbnailPath: document.data()["thumbnailPath"] as? String ?? "",
                                                               ratings: document.data()["ratings"] as? Double ?? 0,
                                                               isSaved: document.data()["isSaved"] as? Int ?? 0,
                                                               numberOfRatings: document.data()["numberOfRatings"] as? Int ?? 0,
                                                               likes: document.data()["likes"] as? Int ?? 0,
                                                               calorie: document.data()["calorie"] as? Int ?? 0,
                                                               protein: document.data()["protein"] as? Double ?? 0,
                                                               fat: document.data()["fat"] as? Double ?? 0,
                                                               sugar: document.data()["sugar"] as? Double ?? 0,
                                                               ingredient: document.data()["ingredient"] as? [String] ?? [""],
                                                               ingredientSummary: document.data()["ingredientSummary"] as? [String] ?? [""],
                                                               method: document.data()["method"] as? [String] ?? [""],
                                                               id: document.documentID))
                        }
                    }
            }
        }
        return list
    }
    
    var suggestionResults: [String]{
        if inputIngredient.isEmpty {
            //searchBarSize = 160.0
            return []
        } else {
            //searchBarSize = 870.0
            //print(searchText)
            return model.allIngredients.filter { $0.contains(inputIngredient.lowercased()) }
        }
    }
    
    var searchBarSize: Double {
        if searchText.isEmpty {
            return 195.0
        } else {
            return 870.0
        }
    }
    
    var ingredientSize: Double{
        if(45.0 * Double(model.searchIngredients.count + 1) < 220){
            return 220
        }
        else{
            return 45.0 * Double(model.searchIngredients.count + 1)
        }
    }
    
    var dislikeSize: Double{
        if(45.0 * Double(model.dislikeIngredients.count + 1) < 200){
            return 200
        }
        else{
            return 45.0 * Double(model.dislikeIngredients.count + 1)
        }
    }
    
    var searchIngredients:[String]{
        model.searchIngredients
    }
    
    var allIngredients:[String]{
        model.allIngredients
    }
    
    func deleteIngredients(at offsets: IndexSet){
        model.delete(at: offsets)
    }
    
    var dislikeIngredients:[String]{
        model.dislikeIngredients
    }
    
    func deleteDislike(at offsets: IndexSet){
        model.deleteDislike(at: offsets)
    }
    
    func addIngerdients(ingredient:String){
        model.add(ingredient: ingredient)
    }
    
    func addDislike(ingredient:String){
        model.addDislike(ingredient: ingredient)
    }
    
    func getAllRecipe(){
        let db = Firestore.firestore()
        
        db.collection("Recipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    //self.model.ratingNumbers = data["ratingNumbers"]as? Int ?? 0
                    self.model.addTotalRecipes(ingredient: document.data()["name"]as? String ?? "")
                }
            }
        }
    }
    
    func getRecipe() -> RecipeDetail {
        return selectedRecipe
    }
    
    func updateSaveCategory(category:Int, recipeName:String) {
        print("HERERER")
        let db = Firestore.firestore()
        db.collection("Recipes").whereField("name", isEqualTo: recipeName).limit(to: 1).getDocuments(completion: { querySnapshot, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }

                guard let docs = querySnapshot?.documents else { return }

                for doc in docs {
//                    let docId = doc.documentID
                    let name = doc.get("name")
//                    print(name)

                    let ref = doc.reference
                    ref.updateData(["isSaved": category])
                }
            })
    }
    
    func selectARecipe(recipeName:String){
        let db = Firestore.firestore()
        
        db.collection("Recipes").whereField("name", isEqualTo: recipeName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        self.selectedRecipe = RecipeDetail(name: document.data()["name"] as? String ?? "",
                                                           methodSummary: document.data()["methodSummary"] as? String ?? "",
                                                           description: document.data()["description"] as? String ?? "",
                                                           fullImagePath: document.data()["fullImagePath"] as? String ?? "",
                                                           thumbnailPath: document.data()["thumbnailPath"] as? String ?? "",
                                                           ratings: document.data()["ratings"] as? Double ?? 0,
                                                           isSaved: document.data()["isSaved"] as? Int ?? 0,
                                                           numberOfRatings: document.data()["numberOfRatings"] as? Int ?? 0,
                                                           likes: document.data()["likes"] as? Int ?? 0,
                                                           calorie: document.data()["calorie"] as? Int ?? 0,
                                                           protein: document.data()["protein"] as? Double ?? 0,
                                                           fat: document.data()["fat"] as? Double ?? 0,
                                                           sugar: document.data()["sugar"] as? Double ?? 0,
                                                           ingredient: document.data()["ingredient"] as? [String] ?? [""],
                                                           ingredientSummary: document.data()["ingredientSummary"] as? [String] ?? [""],
                                                           method: document.data()["method"] as? [String] ?? [""],
                                                           id: document.documentID)
                    }
                }
        }
    }
    
    func getARecipe(myRecipeName:String) -> RecipeDetail{
        var myRecipe:RecipeDetail = RecipeDetail(name: "", methodSummary: "", description: "", fullImagePath: "", thumbnailPath: "", ratings: 99, isSaved: 0, numberOfRatings: 1, likes: 10, calorie: 10, protein: 10, fat: 10, sugar: 10, ingredient: [], ingredientSummary: [], method: [], id: "")
        let db = Firestore.firestore()
        
        db.collection("Recipes").whereField("name", isEqualTo: myRecipeName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        myRecipe = RecipeDetail(name: document.data()["name"] as? String ?? "",
                                                           methodSummary: document.data()["methodSummary"] as? String ?? "",
                                                           description: document.data()["description"] as? String ?? "",
                                                           fullImagePath: document.data()["fullImagePath"] as? String ?? "",
                                                           thumbnailPath: document.data()["thumbnailPath"] as? String ?? "",
                                                           ratings: document.data()["ratings"] as? Double ?? 0,
                                                           isSaved: document.data()["isSaved"] as? Int ?? 0,
                                                           numberOfRatings: document.data()["numberOfRatings"] as? Int ?? 0,
                                                           likes: document.data()["likes"] as? Int ?? 0,
                                                           calorie: document.data()["calorie"] as? Int ?? 0,
                                                           protein: document.data()["protein"] as? Double ?? 0,
                                                           fat: document.data()["fat"] as? Double ?? 0,
                                                           sugar: document.data()["sugar"] as? Double ?? 0,
                                                           ingredient: document.data()["ingredient"] as? [String] ?? [""],
                                                           ingredientSummary: document.data()["ingredientSummary"] as? [String] ?? [""],
                                                           method: document.data()["method"] as? [String] ?? [""],
                                                           id: document.documentID)
                    }
                }
        }
        return myRecipe
    }
    
    func SearchByIngredients(){
        self.searchByIngredientResult = [RecipeDetail]()
        
        let db = Firestore.firestore()
        
        db.collection("Recipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var notIn = true
                    var In = false
                    var Cal = true
                    var Method = true
                    var Handicap = true
                    
                    for ingredient in self.model.dislikeIngredients{
                        if((document.data()["ingredientSummary"] as? [String] ?? [""]).contains(ingredient.lowercased())){
                            notIn = false
                        }
                    }
                    
                    if(Set(self.model.searchIngredients).isSubset(of: document.data()["ingredientSummary"] as? [String] ?? [""])){
                        In = true
                        //self.model.ratingNumbers = data["ratingNumbers"]as? Int ?? 0
                        //self.model.addTotalRecipes(ingredient: document.data()["name"]as? String ?? "")
                    }
                    
                    if(self.calorieChoice != 0){
                        if((document.data()["calorie"] as? Int ?? 0) > (self.calorieChoice * 100)){
                            Cal = false
                        }
                    }
                    
                    if(self.functionChoice == 1){
                        if((document.data()["sugar"] as? Double ?? 0) > 100.0){
                            Handicap = false
                        }
                    }
                    else if(self.functionChoice == 2){
                        if((document.data()["fat"] as? Double ?? 0) > 300.0){
                            Handicap = false
                        }
                    }
                    else if(self.functionChoice == 3){
                        if((document.data()["protein"] as? Double ?? 0) < 400.0){
                            Handicap = false
                        }
                    }
                    
                    
                    if(self.methodChoice == 1){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("bake")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 2){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("barbecue")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 3){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("boil")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 4){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("cut")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 5){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("dessert")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 6){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("fry")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 7){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("grill")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 8){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("omelet")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 9){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("Poaching")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 10){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("roast")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 11){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("Simmering")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 12){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("steam")){
                            Method = false
                        }
                    }
                    if(self.methodChoice == 13){
                        if(!(document.data()["methodSummary"] as? String ?? "").elementsEqual("stew")){
                            Method = false
                        }
                    }
                    
                    if(notIn && In && Cal && Method && Handicap){
                        self.searchByIngredientResult.append(RecipeDetail(name: document.data()["name"] as? String ?? "",
                                                                     methodSummary: document.data()["methodSummary"] as? String ?? "",
                                                                     description: document.data()["description"] as? String ?? "",
                                                                     fullImagePath: document.data()["fullImagePath"] as? String ?? "",
                                                                     thumbnailPath: document.data()["thumbnailPath"] as? String ?? "",
                                                                     ratings: document.data()["ratings"] as? Double ?? 0,
                                                                     isSaved: document.data()["isSaved"] as? Int ?? 0,
                                                                     numberOfRatings: document.data()["numberOfRatings"] as? Int ?? 0,
                                                                     likes: document.data()["likes"] as? Int ?? 0,
                                                                     calorie: document.data()["calorie"] as? Int ?? 0,
                                                                     protein: document.data()["protein"] as? Double ?? 0,
                                                                     fat: document.data()["fat"] as? Double ?? 0,
                                                                     sugar: document.data()["sugar"] as? Double ?? 0,
                                                                     ingredient: document.data()["ingredient"] as? [String] ?? [""],
                                                                     ingredientSummary: document.data()["ingredientSummary"] as? [String] ?? [""],
                                                                     method: document.data()["method"] as? [String] ?? [""],
                                                                     id: document.documentID))
                    }
                }
            }
            self.searchByIngredientResult1 = self.searchByIngredientResult.sorted(by: { $0.likes > $1.likes })
            self.searchByIngredientResult2 = self.searchByIngredientResult.sorted(by: { $0.ratings > $1.ratings})
            self.searchByIngredientResult3 = self.searchByIngredientResult.sorted(by: { $0.calorie > $1.calorie})
            if(self.orderChoice == 0){
                print("0")
                self.searchByIngredientResult = self.searchByIngredientResult1
            }
            else if(self.orderChoice == 1){
                print(self.searchByIngredientResult)
                self.searchByIngredientResult = self.searchByIngredientResult2
            }
            else{
                print("2")
                self.searchByIngredientResult = self.searchByIngredientResult3
            }
        }
    }
    
    
    func getAllIngredients(){
        let db = Firestore.firestore()
        db.collection("Recipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    for ingredient in document.data()["ingredientSummary"] as? [String] ?? [""] {
                        if(!self.model.allIngredients.contains(ingredient)){
                            self.model.allIngredients.append(ingredient)
                        }
                    }
                }
            }
        }
        print("------------------fkkkkkkkkkkk")
        print(self.selectedRecipe)
    }
    
    func removeAllDislikeIngredient(){
        model.dislikeIngredients.removeAll()
    }
    
    func removeAllSearchIngredient(){
        model.searchIngredients.removeAll()
    }
}

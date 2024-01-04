//
//  MorePage.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI
import Combine
import Firebase

struct MorePage: View {
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    @State private var saveConfirmation  = false
    @State private var blacklistConfirmation = false
    @State var isLinkActive = false
    @State var savedRecipes: [[String: Any]] = Storage.shared.retrieveAll()
    let myRating = setStarRating()
    let myLikes = likeViewModel()
    @State var allRecipe = [RecipeDetail]()
    @State var randomInt = Int.random(in: 1...100)
    @State var myCheckDisapper = false

    @State var blacklistRecipes = Storage.shared.retrieveBlacklist()
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Unit Setting")) {
                    Picker("Calories Unit", selection: $unitSelectionViewModel.currentSelection) {
                        Text("KJ").tag(0)
                        Text("KCal").tag(1)
                    }.onReceive(Just(unitSelectionViewModel.currentSelection)) {
                        UserDefaults.standard.set($0, forKey: "unit")
                    }
                }
                if(allRecipe.count > 0){
                    
                    Section(header: Text("Still have no idea? Try this")) {
                        NavigationLink(destination: SearchResultDetailPage(selectedRecipe: allRecipe[randomInt],ratingViewModel: myRating, savedRecipes: $savedRecipes, checkDisappear: $randomInt, blacklistRecipes: $blacklistRecipes, myLikeViewModel: myLikes),isActive: self.$isLinkActive){
                            Label("Hitme", systemImage: "shuffle.circle")
                        }
                    }
                }
                
                Section(header: Text("Privacy"),
                footer: Text("This will reset your saved, liked or blacklist history.")) {
                    Button (role: .destructive, action: { saveConfirmation.toggle() }){
                        Text("Reset Saved Recipes")
                    }.confirmationDialog("You cannot undo this.",
                                         isPresented: $saveConfirmation,
                                         titleVisibility: .visible) {
                        Button("Confirm", role: .destructive){
                            // reset all data
                            Storage.shared.resetSave()
                        }
                    }
                    
                    Button (role: .destructive, action: { blacklistConfirmation.toggle()  }){
                        Text("Reset Blacklisted Recipes")
                    }.confirmationDialog("You cannot undo this.",
                                         isPresented: $blacklistConfirmation,
                                         titleVisibility: .visible) {
                        Button("Confirm", role: .destructive){
                            // reset all data
                            Storage.shared.resetBlacklist()
                        }
                    }
                }
                
                
                
                Section(header: Text("About Us")){
                    Link(destination: URL(string: "https://bitbucket.org/zwan2773/soft3888_tu08_02/src/master/")!) {
                        Label("Bitbucket Repo", systemImage: "xserve")
                    }
                    Link(destination: URL(string: "mailto:recipedia.usyd@gmail.com?subject=Hi!")!) {
                        Label("Contact Us", systemImage: "exclamationmark.bubble")
                    }
                }
            }.navigationTitle("More")
        }.onAppear{
            getARandomRecipe()
            isLinkActive = false
        }//.foregroundColor(Color.primary.opacity(0.6))
    }
    
    func getARandomRecipe(){
        let db = Firestore.firestore()
        let randomDouble = Double.random(in: 1...100)
        let randomBool = Bool.random()
        //var quotes = db.collection("Recipes");
        
        db.collection("Recipes")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if (blacklistRecipes.contains(document.data()["name"] as? String ?? "")) {
                            continue
                        }
                        allRecipe.append(RecipeDetail(name: document.data()["name"] as? String ?? "",
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
}


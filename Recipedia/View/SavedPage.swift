//
//  SavedPage.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI

struct SavedPage: View {
    @State var blacklistRecipes = Storage.shared.retrieveBlacklist()
    @ObservedObject var savePageViewModel = SavePageViewModel()
    @State private var selectedCategory = 1
    private var options = ["Favourites", "Plan to cook"]
    @EnvironmentObject var detailPageViewModel : DetailPageViewModel
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    @State var isActive : Bool = false
    
   
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Your favourite")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Saved Recipes")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.purple)
                    }
                    .padding(.leading, 15)
                    Spacer()
                }
                VStack {
                    Picker("Favourites", selection: $selectedCategory){
                        
                        ForEach(options, id:\.self) {
                                Text($0)
                                .tag(options.firstIndex(of: $0)! + 1)
                            }
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    
                    ScrollView(.vertical, showsIndicators: true){
                        
                        
                        LazyVStack (alignment: .leading) {
                            
                            ForEach (savePageViewModel.savedCategoryRecipes) { recipeDets in
                                Group {
                                    
                                    if (recipeDets.isSaved == selectedCategory) {
//                                        let blacklistTmp = Storage.shared.retrieveBlacklist()
                                           
                                        if (!blacklistRecipes.contains(recipeDets.name)) {
                                            let myRating = setStarRating()
                                            let myLikes = likeViewModel()
                                            NavigationLink(
                                                destination: SavedDetailPage(savePageViewModel:savePageViewModel, selectedRecipe:recipeDets, ratingViewModel: myRating, blacklistRecipes: $blacklistRecipes, myLikeViewModel: myLikes),
                                                label: {
                                                    SaveCard(recipeDetail: recipeDets, savePageViewModel: savePageViewModel)
                                                }).buttonStyle(PlainButtonStyle())
                                        }
                                              
                                            
                                    }
                                   
                                }
                                
                            }
                        }
                    }
                }
            }.environmentObject(unitSelectionViewModel)
            .navigationBarTitle("Save")
                .navigationTitle("Save")
                .navigationBarHidden(true)
            
        }.onAppear{
            print("Save Page loaded")
//            blacklist = Storage.shared.retrieveBlacklist()
            savePageViewModel.getSavedRecipes()
            print("\n\n\n\n")
            
//            for recipe in savePageViewModel.getRecipes() {
//                print(recipe.name)
//            }
            print("\n\n\n\n")
        }
    }
    
    init() {
//        savePageViewModel.setBlacklist(blacklist_: blacklist)
        savePageViewModel.getData()
        savePageViewModel.getSavedRecipes()
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
        
//        detailPageViewModel.getData()
//        Storage.shared.retrieveAll(category: selectedCategory)
//        UISegmentedControl.appearance().selectedSegmentTintColor = .systemOrange
//            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
}

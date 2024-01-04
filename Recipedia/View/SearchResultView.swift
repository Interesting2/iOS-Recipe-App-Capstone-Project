//
//  SavedPage.swift
//  Recipedia
//
//  Created by Andrew Hou
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var searchModel:getSearchPage
    @State var savedRecipes: [[String: Any]] = Storage.shared.retrieveAll()
//    @State var blacklistRecipes = Storage.shared.retrieveBlacklist()
    
    
    @Binding var blacklistRecipes : [String]
    @State var useless = 0

    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: true){
                LazyVStack (alignment: .leading) {
                    ForEach (searchModel.searchByIngredientResult) { recipeDets in
                        if (!blacklistRecipes.contains(recipeDets.name)) {
                            //detailPageViewModel.selectedRecipe = recipeDets
                            let myRating = setStarRating()
                            let myLikes = likeViewModel()
                            NavigationLink(destination: SearchResultDetailPage(selectedRecipe: recipeDets,ratingViewModel: myRating, savedRecipes: $savedRecipes, checkDisappear: $useless, blacklistRecipes: $blacklistRecipes, myLikeViewModel: myLikes)) {
                                RegularCard(recipeDetail: recipeDets, savedRecipes: $savedRecipes)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }.navigationTitle("Search Result")
            }.onAppear() {
//                savePageViewModel.getData()
//                savePageViewModel.getSavedRecipes()
                savedRecipes = Storage.shared.retrieveAll()
//                searchModel.SearchByIngredients()
//                print("\n\n\n\n")
//                print("SearchResultView onappear")
//                for recipe in savePageViewModel.getRecipes() {
//                    print(recipe.name)
//                }
//                print("\n\n\n\n")
            }     
    }
        //        .background(Color.primary.opacity(0.06).ignoresSafeArea())
    
    init(searchModel_: getSearchPage, blacklistRecipes_: Binding<[String]>) {
        self.searchModel = searchModel_
        self._blacklistRecipes = blacklistRecipes_
//        searchModel.searchByIngredientResult
    }
}

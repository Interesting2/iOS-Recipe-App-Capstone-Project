//
//  HomePage.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI
import Combine

struct HomePage: View {
    var animation: Namespace.ID
    @Binding var blacklistRecipes : [String]

    @EnvironmentObject var detailPageViewModel : DetailPageViewModel
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    @State public var selectedOrder = UserDefaults.standard.integer(forKey: "orderPreference")
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true){
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("For you")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Top Recipes")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                }
                .padding(.leading, 15)
                Spacer()
                
                Picker("Ordered By", selection: $selectedOrder) {
                    Text("Popularity").tag(0)
                    Text("Rating").tag(1)
                }.padding(/*@START_MENU_TOKEN@*/[.top, .trailing], 22.0/*@END_MENU_TOKEN@*/)
                    .onReceive(Just(selectedOrder)) {
                        UserDefaults.standard.set($0, forKey: "orderPreference")
                    }
            }
            
            
            LazyVStack (alignment: .leading) {
                Group {
                    if ( selectedOrder == 0) {
                        ForEach (detailPageViewModel.HomepageList1){ recipeDets in
                            if (!blacklistRecipes.contains(recipeDets.name)) {
                                HomePageCard(recipeDetail: recipeDets, animation: animation)
                                    .environmentObject(unitSelectionViewModel)
                                    .onTapGesture {
                                        print("tapped home card")
                                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                                            detailPageViewModel.selectedRecipe = recipeDets
                                            detailPageViewModel.show.toggle()
                                        }
                                    }
                            }
                           
                        }
                    }else {
                        ForEach (detailPageViewModel.HomepageList2){ recipeDets in
                            if (!blacklistRecipes.contains(recipeDets.name)) {
                                HomePageCard(recipeDetail: recipeDets, animation: animation)
                                    .environmentObject(unitSelectionViewModel)
                                    .onTapGesture {
                                        print("tapped home card")
                                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                                            detailPageViewModel.selectedRecipe = recipeDets
                                            detailPageViewModel.show.toggle()
                                        }
                                    }
                            }
                    }

                    }
                }
                
                
                
            }
        }.onAppear{
            detailPageViewModel.getData()
            blacklistRecipes = Storage.shared.retrieveBlacklist()
            
        }
    
    }
}

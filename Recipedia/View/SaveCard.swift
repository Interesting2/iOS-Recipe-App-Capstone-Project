//
//  RegularCard.swift
//  Recipedia
//
//  Created by Lei io tou on 23/8/2022.
//

import SwiftUI
import NukeUI

struct SaveCard: View {
    var recipeDetail : RecipeDetail
//    @State var savedRecipes = Storage.shared.retrieveAll()
    @ObservedObject var savePageViewModel : SavePageViewModel

    @Environment(\.colorScheme) var color
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    @State private var showingAlert = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill()
            //color == .dark ? Color.black : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0)
                .foregroundColor(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.2) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
//                .foregroundColor(.white)
                .aspectRatio(2.2/1, contentMode: .fit)
            HStack {
                
                LazyImage(url: URL(string: recipeDetail.fullImagePath))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .cornerRadius(15.0)
                    .padding([.top, .leading, .bottom])
                
                
                 
            
                VStack (alignment: .leading){
                    Text(shortNameGenerator(recipeDetail.name))
                        .font(.system(.title2))
                        .padding(.top)
                    Text(recipeDetail.methodSummary)
                            .padding([.bottom, .trailing])
                            .font(.system(.headline))
                    Spacer()
                    
                    Group {
                        HStack(alignment: .center){
                            
                            Image(systemName: "hand.thumbsup.fill")
                                .imageScale(.small)
                            Text("\(recipeDetail.likes)")
                                .font(.callout)
                            Image(systemName: "flame")
                                .imageScale(.small)
                            Text(unitConverter(calorie: recipeDetail.calorie , unit: unitSelectionViewModel))
                                .layoutPriority(200)
                                .font(.callout)
                            Text("\(recipeDetail.ratings, specifier: "%.1f")")
                                .font(.callout)
                            
                            Button(action: {
                                // unsave
                                Storage.shared.unsave(recipeName: recipeDetail.name)
                                showingAlert.toggle()


                            }) {
                                Image(systemName: "bookmark.fill")
//                                    .renderingMode(.original)
//                                    .imageScale(.medium)
//                                if (savedRecipes.contains{ Array($0.keys)[0] == recipeDetail.name }) {
//
//                                } else {
//                                    Image(systemName: "bookmark")
//                                        .renderingMode(.original)
//                                        .imageScale(.medium)
//                                }
                                    //.padding([.bottom, .trailing])
                                Spacer()
                            }.alert("Success", isPresented: $showingAlert) {
                                Button("Got it", role: .cancel) {
                                    // retrieve updated saved recipes again
                                    savePageViewModel.getSavedRecipes()
                                }
                            } message: {
                                Text("Unsaved recipe: " + recipeDetail.name)
                            }.frame(width: 15)
                            
                        }.frame(height: 20)
                            .layoutPriority(100)
//                            .background(Color.red)
                            
                    }
                    Spacer()
                    
                }
                Spacer()
            }
        }
        .padding(.horizontal, 9.0)
        
    }
}

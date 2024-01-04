//
//  SearchResultDetailPage.swift
//  Recipedia
//
//  Created by Lei io tou on 8/9/2022.
//

import SwiftUI
import NukeUI

struct SearchResultDetailPage: View {
//    @ObservedObject var savePageViewModel : SavePageViewModel
//    var animation: Namespace.ID
    @Environment(\.dismiss) var dismiss

    var selectedRecipe : RecipeDetail
    @ObservedObject var ratingViewModel:setStarRating
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    @Environment(\.colorScheme) var color
    @Binding var savedRecipes: [[String: Any]]
    @Binding var checkDisappear:Int

    
    @State private var showingAlert = false
    @State private var savedAlert = false
    
    @State private var savedCategory = 1
    
    @State private var blacklist = false
    @State private var showBlacklistAlert = false
    @State private var successAlert = false
    
    @Binding var blacklistRecipes : [String]
    @State var isDisplayedOnce = false
    @ObservedObject var myLikeViewModel : likeViewModel
    
    var body: some View {
        ScrollView {
            ZStack {
                
                LazyImage(url: URL(string: selectedRecipe.fullImagePath), resizingMode: .aspectFill)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                
            }
            
            VStack {
                HStack{
                    VStack{
                        Text(selectedRecipe.name)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }.padding(.leading)
                    Spacer()
                }
                
                Group () {
                    HStack(alignment: .top){
    //                    Image(systemName: selectedRecipe.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
    //                        .padding([.leading, .bottom])
    //                        .imageScale(.medium)
                       Button(action: {
                            myLikeViewModel.setLikes(RecipeID: selectedRecipe.id)
                        }, label: {
                            if myLikeViewModel.isLiked{
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(color == .dark ? .white : .black)
                                    .padding([.leading, .bottom])
                                    .imageScale(.medium)
                            } else{
                                Image(systemName: "hand.thumbsup")
                                    .foregroundColor(color == .dark ? .white : .black)
                                    .padding([.leading, .bottom])
                                    .imageScale(.medium)
                            }
                        })
                        Text("\(myLikeViewModel.getLikes(RecipeID:selectedRecipe.id))")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.title3)
                            .padding([.bottom, .trailing])
                        Image(systemName: "flame")
                            .imageScale(.medium)
                            .padding(.bottom)
                        Text(unitConverter(calorie:selectedRecipe.calorie, unit: unitSelectionViewModel))
                            .font(.title3)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding([.bottom, .trailing])
                        Text(String(format: "%.1f", ratingViewModel.getAverageRating(RecipeID: selectedRecipe.id)))
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.title3)
                            .padding([.bottom, .trailing])
                    
                        
                        /* Blacklist button*/
                        Button(action: {
                            
                            showBlacklistAlert.toggle()
                            
                        }) {
                            Image(systemName: "xmark.bin")
                                .resizable()
                                .foregroundColor(color == .dark ? .white : .black)
                                .frame(width: 20, height: 20)
                                .padding()
                        }.alert("Important Confirmation", isPresented: $showBlacklistAlert) {
                            Button("Confirm") {
//
                                successAlert.toggle()
//                                dismiss()
                            }
                            Button("Cancel", role: .cancel){}
                        }message: {
                            Text("Are you sure you want to blacklist this recipe?")
                        }
                        .frame(width: 20, height: 20)
                        
                        // invisible button for success confirmation
                        Button("Confirm") {
//                               
                        }.alert("Success", isPresented: $successAlert) {
                            Button("Got It", role: .cancel){
                                // show success alert
                                Storage.shared.blacklist(recipeName: selectedRecipe.name)
                                blacklistRecipes = Storage.shared.retrieveBlacklist()
    //                            isActive = false
                                blacklist = true
                                dismiss()
                            }
                        }.opacity(0)
                        
                       
                          
                        Button("Button") {
                            
                        }.alert("Success", isPresented: $savedAlert) {
                            Button("Got it", role: .cancel) {
                                Storage.shared.save(category: savedCategory, recipeName: selectedRecipe.name)
    //                            savePageViewModel.getSavedRecipes() // update saved recipes in VM
                                savedRecipes = Storage.shared.retrieveAll()
                            }
                        } message: {
                            Text("Saved recipe: " + selectedRecipe.name)
                        }.opacity(0)
                        
                        Spacer()
                    }.frame(height: 20)

                    Text(selectedRecipe.description)
                        .padding([.leading, .bottom, .trailing])
                        .font(.body)
                    
                    VStack(){
                        HStack{
                            Text("Nutritions")
                                .padding([.leading, .bottom])
                                .font(.title)
                            Spacer()
                        }
                        
                        HStack{
                            Text("* Protein: " + String(format: "%.1f", selectedRecipe.protein))
                                .padding([.leading])
                            Spacer()
                        }
                        
                        HStack{
                            Text("* Fat: " + String(format: "%.1f", selectedRecipe.fat))
                                .padding([.leading])
                            Spacer()
                        }
                        
                        HStack{
                            Text("* Sugar: " + String(format: "%.1f", selectedRecipe.sugar))
                                .padding([.leading, .bottom])
                            Spacer()
                        }
                    }
                    
                    HStack(){
                        Text("Ingredients")
                            .padding([.leading, .bottom])
                            .font(.title)
                        Spacer()
                    }
                    ForEach (selectedRecipe.ingredient, id:\.self) { ingredient in
                        HStack {
                            Text("* \(ingredient)")
                                .padding([.leading])
                            Spacer()
                        }
                    }
                    
                    HStack(){
                        Text("Methods")
                            .padding([.leading, .bottom, .top])
                            .font(.title)
                        Spacer()
                    }
                    ForEach (selectedRecipe.method, id:\.self) { method in
                        HStack {
                            Text(method)
                                .padding([.leading, .bottom])
                            Spacer()
                        }
                    }
                    
                    VStack{
                             HStack{
                                        Button(action: {
                                            print("test")
                                            print(selectedRecipe.id)
                                            ratingViewModel.setRating(index: 1,RecipeID: selectedRecipe.id)
                                        }, label: {
                                            if ratingViewModel.getRating < 1{
                                                Image(systemName: "star")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            } else{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            }
                                        })
                                        Button(action: {
                                            ratingViewModel.setRating(index: 2,RecipeID: selectedRecipe.id)
                                        }, label: {
                                            if ratingViewModel.getRating < 2{
                                                Image(systemName: "star")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            } else{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            }
                                        })
                                        Button(action: {
                                            ratingViewModel.setRating(index: 3,RecipeID:selectedRecipe.id)
                                        }, label: {
                                            if ratingViewModel.getRating < 3{
                                                Image(systemName: "star")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            } else{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            }
                                        })
                                        Button(action: {
                                            ratingViewModel.setRating(index: 4,RecipeID:selectedRecipe.id)
                                        }, label: {
                                            if ratingViewModel.getRating < 4{
                                                Image(systemName: "star")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            } else{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            }
                                        })
                                        Button(action: {
                                            ratingViewModel.setRating(index: 5,RecipeID:selectedRecipe.id)
                                        }, label: {
                                            if ratingViewModel.getRating < 5{
                                                Image(systemName: "star")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            } else{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(/*@START_MENU_TOKEN@*/.yellow/*@END_MENU_TOKEN@*/)
                                            }
                                        })
                                        Text(String(ratingViewModel.getRating))
                                }
                    }
                
                    
                    Spacer()
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            //            .zIndex(1)
                       
                            .cornerRadius(20) /// make the background rounded
            //                .opacity(0.5)
                            .background( /// apply a rounded border
                                ZStack(alignment: .topLeading) {
            //                        Color.gray
                                    RoundedRectangle(cornerRadius: 20)
            //                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                        // .foregroundColor(Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1))
                                        
                                        .foregroundColor(color == .dark ? .black : Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1.0))
                                        // .shadow(radius: 2)
            //                            .background(Color.gray)
            //                            .backgroound(Color.init(red: 255, green: 245, blue: 158))

            //                            .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 5)
            //                            .background(Color(red: 0.888, green: 0.888, blue: 0.888))
                                    
                                    ZStack() {
                                        Button(action: {
                                            // if already saved, then unsave
                                            // TODO
                                            if (savedRecipes.contains{ Array($0.keys)[0] == selectedRecipe.name }) {
                                                Storage.shared.unsave(recipeName: selectedRecipe.name)
//                                                savePageViewModel.getSavedRecipes() // update saved recipes in VM
                                                savedRecipes = Storage.shared.retrieveAll()
                                                showingAlert.toggle()
                                            }
                                        }) {
                                            if (savedRecipes.contains{ Array($0.keys)[0] == selectedRecipe.name }) {
                                                
                                                Image(systemName: "bookmark.fill")
                                                    .resizable()
                                                      .frame(width: 15, height: 20)
                                                      .foregroundColor(.white)
                                                      .padding()
                                                      .background(Color.orange)
                                                      .clipShape(Circle())
                        //                                .renderingMode(.original)
                        //                                .imageScale(.medium)
                                            } else {
                                                Menu {
                                                    Button("Favourites", action: {
                                                        print("Favourites")
                                                        savedCategory = 1
                                                        savedAlert.toggle()
                                                        

                                                    })
                                                    Button("Plan to cook", action: {
                                                        print("Plan to cook")
                                                        savedCategory = 2
                                                        savedAlert.toggle()
                                                    })
                                                } label: {
                                                    Image(systemName: "bookmark")
                                                        .resizable()
                                                        .imageScale(.medium)
                                                          .frame(width: 15, height: 20)
                                                          .foregroundColor(Color.black)
            //                                              .border(Color.black, width: 1)
                                                          .padding()
                                                          .background(Color.orange)
                                                          .clipShape(Circle())
                                                        
                        //                                   .renderingMode(.original)
                        //                                   .imageScale(.medium)
                                                }
                                                   
                        //
                                            }
                                                //.padding([.bottom, .trailing])
                    //                        Spacer()
                                        }.alert("Success", isPresented: $showingAlert) {
                                            Button("Got it", role: .cancel) {
                                                
                                            }
                                        } message: {
                                            Text("Unsaved recipe: " + selectedRecipe.name)
                                        }.frame(width: 10, height: 15)
                                            .zIndex(1)
                                            .offset(x: -25, y: -10)
                                            

                                        
                                    }.frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                        
                                    
                                }.offset(x: 0, y: -20).zIndex(1)
                                
                            )
            
            
        }
        .ignoresSafeArea(.all, edges: .top)
        .statusBar(hidden: true)
        .disabled(blacklist)
        .onAppear{
            checkDisappear = Int.random(in: 1...100)
            //myLikeViewModel.getLikesFromDB(myRecipeID: selectedRecipe.id)

            savedRecipes = Storage.shared.retrieveAll()
            blacklistRecipes = Storage.shared.retrieveBlacklist()
            
            if (!isDisplayedOnce) {
                // check if user blacklisted a recipe in another view
                if (blacklistRecipes.contains(selectedRecipe.name)) {
                    dismiss()
                    isDisplayedOnce = true
                }
            }
        }
    }
}


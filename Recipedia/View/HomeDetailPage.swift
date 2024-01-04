//
//  DetailPage.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI
import NukeUI


struct HomeDetailPage: View {

    @ObservedObject var detailPageViewModel : DetailPageViewModel
    var animation: Namespace.ID
    @Environment(\.colorScheme) var color

    //var imageType: String
    @State var savedRecipes: [[String: Any]] = Storage.shared.retrieveAll()

    @ObservedObject var ratingViewModel:setStarRating
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    @Binding var blacklistRecipes : [String]

    @State private var showingAlert = false
    
    @State private var savedAlert = false
    @State private var savedCategory = 1
    
    @State private var blacklist = false
    @State private var showBlacklistAlert = false
    @State private var successAlert = false
    
    @State var isDisplayedOnce = false

    @ObservedObject var myLikeViewModel : likeViewModel


    
    var body: some View {
        ScrollView {
            ZStack {
                
                LazyImage(url: URL(string: detailPageViewModel.selectedRecipe.fullImagePath), resizingMode: .aspectFill)
                    .matchedGeometryEffect(id: detailPageViewModel.selectedRecipe.fullImagePath, in: animation)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                
                VStack{
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.interactiveSpring(response: 0.1, dampingFraction: 2, blendDuration: 0.1)){
                                                            detailPageViewModel.show.toggle()
                            }
                        }){
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .foregroundColor(Color.black.opacity(0.7))
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .clipShape(Circle())
                                
                        }
                        
                        
                    }.padding()
                    Spacer()
                    
                }
            }
            
            VStack {
                HStack{
                    VStack{
                        Text(detailPageViewModel.selectedRecipe.name)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }.padding(.leading)
                    Spacer()
                }
                
                Group () {
                    HStack(alignment: .top){
    //                    Image(systemName: detailPageViewModel.selectedRecipe.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
    //                        .padding([.leading, .bottom])
    //                        .imageScale(.medium)
                        Button(action: {
                            myLikeViewModel.setLikes(RecipeID: detailPageViewModel.selectedRecipe.id)
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
                        Text("\(myLikeViewModel.getLikes(RecipeID:detailPageViewModel.selectedRecipe.id))")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.title3)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding([.bottom, .trailing])
                        Image(systemName: "flame")
                            .imageScale(.medium)
                            .padding(.bottom)
                        Text(unitConverter(calorie: detailPageViewModel.selectedRecipe.calorie, unit: unitSelectionViewModel))
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.title3)
                            .padding([.bottom, .trailing])
                        Text(String(format: "%.1f", ratingViewModel.getAverageRating(RecipeID: detailPageViewModel.selectedRecipe.id)))
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
                                Storage.shared.blacklist(recipeName: detailPageViewModel.selectedRecipe.name)
                                blacklistRecipes = Storage.shared.retrieveBlacklist()
    //                            isActive = false
                                blacklist = true
                                detailPageViewModel.show = false
                                
                            }
                        }.opacity(0)
                        
                        
                        
                        Button("Button") {
                            
                        }.alert("Success", isPresented: $savedAlert) {
                            Button("Got it", role: .cancel) {
                                Storage.shared.save(category: savedCategory, recipeName: detailPageViewModel.selectedRecipe.name)
                                savedRecipes = Storage.shared.retrieveAll()
                            }
                        } message: {
                            Text("Saved recipe: " + detailPageViewModel.selectedRecipe.name)
                        }.opacity(0)
                        
                        Spacer()
                    }.frame(height: 20)
                    .disabled(blacklist)

                    Text(detailPageViewModel.selectedRecipe.description)
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
                            Text("* Protein: " + String(format: "%.1f", detailPageViewModel.selectedRecipe.protein))
                                .padding([.leading])
                            Spacer()
                        }
                        
                        HStack{
                            Text("* Fat: " + String(format: "%.1f", detailPageViewModel.selectedRecipe.fat))
                                .padding([.leading])
                            Spacer()
                        }
                        
                        HStack{
                            Text("* Sugar: " + String(format: "%.1f", detailPageViewModel.selectedRecipe.sugar))
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
                    ForEach (detailPageViewModel.selectedRecipe.ingredient, id:\.self) { ingredient in
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
                    ForEach (detailPageViewModel.selectedRecipe.method, id:\.self) { method in
                        HStack {
                            Text(method)
                                .padding([.leading, .bottom])
                            Spacer()
                        }
                    }
                    
                    VStack{
                                        HStack{
                                            Button(action: {
                                                ratingViewModel.setRating(index: 1,RecipeID:detailPageViewModel.selectedRecipe.id)

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
                                                ratingViewModel.setRating(index: 2,RecipeID:detailPageViewModel.selectedRecipe.id)

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
                                                ratingViewModel.setRating(index: 3,RecipeID:detailPageViewModel.selectedRecipe.id)

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
                                                ratingViewModel.setRating(index: 4,RecipeID:detailPageViewModel.selectedRecipe.id)

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
                                                ratingViewModel.setRating(index: 5,RecipeID:detailPageViewModel.selectedRecipe.id)

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
                    }.disabled(blacklist)
                    
                    Spacer()
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
             .cornerRadius(20) /// make the background rounded
            .background(
                ZStack(alignment: .topLeading) {
//                        Color.gray
                    RoundedRectangle(cornerRadius: 20)
//                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        // .foregroundColor(Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 1))
//                        .shadow(radius: 2)
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
                            if (savedRecipes.contains{ Array($0.keys)[0] == detailPageViewModel.selectedRecipe.name }) {
                                Storage.shared.unsave(recipeName: detailPageViewModel.selectedRecipe.name)
                                savedRecipes = Storage.shared.retrieveAll()
                                showingAlert.toggle()
                            }
                        }) {
                            if (savedRecipes.contains{ Array($0.keys)[0] == detailPageViewModel.selectedRecipe.name }) {
                                
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
                                }
                                   
        //
                            }
                                //.padding([.bottom, .trailing])
                            
                        }.alert("Success", isPresented: $showingAlert) {
                            Button("Got it", role: .cancel) {
                                
                            }
                        } message: {
                            Text("Unsaved recipe: " + detailPageViewModel.selectedRecipe.name)
                        }.frame(width: 10, height: 15)
                            .zIndex(1)
                            .offset(x: -25, y: -10)
                            .disabled(blacklist)
                        
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }.offset(x: 0, y: -20).zIndex(1)
                
            )
        }
        .ignoresSafeArea(.all, edges: .top)
        .statusBar(hidden: true)
        .onAppear() {
            blacklistRecipes = Storage.shared.retrieveBlacklist()
            myLikeViewModel.getLikes(RecipeID:detailPageViewModel.selectedRecipe.id)
            if (!isDisplayedOnce) {
                // check if user blacklisted a recipe in another view
                if (blacklistRecipes.contains(detailPageViewModel.selectedRecipe.name)) {
                    detailPageViewModel.show = false
                    isDisplayedOnce = true
                }
            }
        }
        
    }
}

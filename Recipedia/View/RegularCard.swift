import SwiftUI
import NukeUI

func shortNameGenerator(_ description : String) -> String {
    let delimiter = ","
    let shortDescription = description.components(separatedBy: delimiter)
    return shortDescription[0]
}

struct RegularCard: View {
    var recipeDetail : RecipeDetail
//    @ObservedObject var savePageViewModel : SavePageViewModel

    @Environment(\.colorScheme) var color
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    @Binding var savedRecipes: [[String: Any]]
    
    
    
    @State private var showingAlert = false
    @State private var savedAlert = false
    
    @State private var savedCategory = 1
    
    
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
                    .cornerRadius(10.0)
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
                                .fixedSize(horizontal: true, vertical: false)
                            Image(systemName: "flame")
                                .imageScale(.small)
                            Text(unitConverter(calorie: recipeDetail.calorie , unit: unitSelectionViewModel))
                                .font(.callout)
                                .fixedSize(horizontal: true, vertical: false)
                            Text("\(recipeDetail.ratings, specifier: "%.1f")")
                                .font(.callout)
                            
                            Button(action: {
                                print("Regular card save button pressed")
//                                for recipe in savePageViewModel.getRecipes() {
//
//                                    let recipeName = recipe.name
//                                    print(recipeName)
//                                    if (recipeName == recipeDetail.name) {
//                                        print("Unsaving recipe: " + recipeName)
//                                        // unsave
//                                        Storage.shared.unsave(recipeName: recipeDetail.name)
//                                        // retrieve updated saved recipes again
//                                        savePageViewModel.getSavedRecipes()
//                                    } else {
//                                        print("Saving recipe: " + recipeName)
//                                        Storage.shared.save(category: recipe.isSaved, recipeName: recipeName)
//                                        savePageViewModel.getSavedRecipes()
//                                    }
//                                }
//                                var exist = false
                                for recipe in savedRecipes {
                                    if (Array(recipe.keys)[0] == recipeDetail.name) {
                                        Storage.shared.unsave(recipeName: recipeDetail.name)
                                        savedRecipes = Storage.shared.retrieveAll()
                                        showingAlert.toggle()

//                                        exist = true
                                    } 
                                }
                                
                                
                               
                            }) {
                                if (savedRecipes.contains{ Array($0.keys)[0] == recipeDetail.name }) {
                                    Image(systemName: "bookmark.fill")
//                                        .renderingMode(.original)
//                                        .imageScale(.medium)
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
            //                                   .renderingMode(.original)
            //                                   .imageScale(.medium)
                                    }
                                }
                                    //.padding([.bottom, .trailing])
     
                                
                            }.alert("Success", isPresented: $showingAlert) {
                                Button("Got it", role: .cancel) {
                                    
                                }
                            } message: {
                                Text("Unsaved recipe: " + recipeDetail.name)
                            }.frame(width: 15)
                                

                            
                            Button("Button") {
                                
                            }.alert("Success", isPresented: $savedAlert) {
                                Button("Got it", role: .cancel) {
                                    Storage.shared.save(category: savedCategory, recipeName: recipeDetail.name)
//                                    savePageViewModel.getSavedRecipes() // update saved recipes in VM
                                    savedRecipes = Storage.shared.retrieveAll()
                                }
                            } message: {
                                Text("Saved recipe: " + recipeDetail.name)
                            }.opacity(0)
                            
                            Spacer()
                            
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
        .onAppear() {
            print("Regular card on appear")

//            print(recipeDetail.name)
            
        }
        
    }
}

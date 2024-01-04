//
//  SavePageBox.swift
//  Recipedia
//
//  Created by Lei Io Tou on 03/10/2022.
//

import Foundation

import SwiftUI


struct SavePageBox<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @Binding var savedRecipes: [[String: Any]]
    var recipeName: String
    @ObservedObject var searchViewModel:getSearchPage
    let presenting: Presenting
    
    @State private var showingAlert = false
    @State var selectionIndex: Int = 0

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                   .disabled(isShowing)
                
                VStack {
                    // Use menu
//                    Picker(selection: .constant(0),
//                                   label: Text("Picker"),
//                                   content: {
//                                Text("").tag(0)
//                                Text("Favourites").tag(1)
//                                Text("Plan to cook").tag(2)
//                                   })
//                                .padding()
//                            .pickerStyle(MenuPickerStyle())
//                            .onChange(of: selectionIndex) { _ in
//                                showingAlert.toggle()
//                            }
//                    Section {
//                        
//                    }.alert("Confirm selection?", isPresented: $showingAlert) {
//                        Button("Confirm", role: .destructive) {
//                            print("Selected category index is: " + String(selectionIndex))
//                            if (selectionIndex != 0) {
//                                Storage.shared.save(category: selectionIndex, recipeName: recipeName)
//                                savedRecipes = Storage.shared.retrieveAll()
//                            }
//                            
//                        }
//                    }
//                    Text("Selected value \(selectionIndex)")
                    
                }.opacity(isShowing ? 1 : 0)
                    
            }
        }
    }
}

extension View {
    
    func savePageBox(isShowing: Binding<Bool>, searchViewModel: getSearchPage, recipeName: String, savedRecipes: Binding<[[String: Any]]>) -> some View {
        SavePageBox(isShowing: isShowing, savedRecipes: savedRecipes, recipeName: recipeName, searchViewModel: searchViewModel,
                       presenting: self)
    }
}
/*
VStack() {
    
    
    ZStack(alignment:.topLeading) {
        Button(action: {
            // close button
            print("Clicked close button")
            isShowing.toggle()
            
        }) {
            Image(systemName: "x.circle")
                .resizable()
                .foregroundColor(.black)
                .frame(width: 30, height: 30)
                
        }.zIndex(1)
       
        
        Form {
            List {
                Button(action: {
                    Storage.shared.save(category: 1, recipeName: recipeName)
                    savedRecipes = Storage.shared.retrieveAll()
//                                    searchViewModel.updateSaveCategory(category: 1, recipeName: recipeName)
                    showingAlert = true
                }) {
        //
                    HStack {
                        Text("Favourites")
                            .foregroundColor(.brown)
                        Image(systemName: "heart.fill")
                            
                            .imageScale(.medium)
                    }.frame(maxWidth: .infinity)
                        .frame(height: 50)
                    
                }.alert("Success", isPresented: $showingAlert) {
//                                    Alert(title: Text("Saved recipe to Favourites"),
//
//                                    )
                    Button("Got it", role: .cancel) {
                        isShowing.toggle()
                    }


                } message: {
                    Text("Saved recipe to Favourites")
                }
                .padding(.leading)
                
                Button(action: {
                    Storage.shared.save(category: 2, recipeName: recipeName)
                    savedRecipes = Storage.shared.retrieveAll()
//                                    searchViewModel.updateSaveCategory(category: 2, recipeName: recipeName)
                    showingAlert.toggle()
                }) {
                    
                    HStack {
                        
                        Text("Plan to cook")
                            .foregroundColor(.brown)
                            
                        Image(systemName: "pencil.circle.fill")
                            .renderingMode(.original)
                            .imageScale(.medium)
                    }.frame(maxWidth: .infinity)
                        .frame(height: 50)

                    
                }.alert("Success", isPresented: $showingAlert) {
                    Button("Got it", role: .cancel) {
                        isShowing.toggle()
                    }


                } message: {
                    Text("Saved recipe to Plan to cook")
                }
                .padding(.leading)
                
            }
//                    .frame(width: 300, height: 200)
        }
    }.background(Color.red)
        .frame(maxWidth: 300, maxHeight: 190)

    
      
  }
//                .position(x:deviceSize.size.width / 2, y:deviceSize.size.height / 2 + 170)
    .cornerRadius(15)
    .shadow(radius: 1)
*/

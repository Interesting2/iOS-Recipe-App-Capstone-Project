//
//  TextFieldAlert.swift
//  HelloWorld
//
//  Created by Andrew Hou on 29/9/2022.
//

import Foundation
import SwiftUI

struct TextFieldAlertIngredient<Presenting>: View where Presenting: View {
    
    @ObservedObject var searchModel:getSearchPage
    @Binding var isShowing: Bool
    let presenting: Presenting
    let title: String
    @Environment(\.colorScheme) var color
    @FocusState private var myKeyborad :Bool
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text("Add a ingredient")
                    TextField(self.title, text: $searchModel.inputIngredient).focused($myKeyborad)
                    
                    if(!searchModel.suggestionResults.isEmpty){
                        if #available(iOS 16.0, *) {
                            List(searchModel.suggestionResults, id: \.self) { suggestion in
                                ZStack {
                                    Text(suggestion).onTapGesture {
                                        searchModel.inputIngredient = suggestion
                                    }
                                }.listRowBackground(color == .dark ? Color.gray : Color.white)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).listStyle(.plain)
//                                .scrollContentBackground(.hidden)
                        } else {
                            // Fallback on earlier versions
                            List(searchModel.suggestionResults, id: \.self) { suggestion in
                                ZStack {
                                    Text(suggestion).onTapGesture {
                                        searchModel.inputIngredient = suggestion
                                    }
                                }.listRowBackground(color == .dark ? Color.gray : Color.white)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).listStyle(.plain)
                        }
                    }
                    
                    Divider()
                    HStack {
                        Button(action: {
                            myKeyborad = false
                            searchModel.inputIngredient = ""
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("cancel")
                        }
                        Spacer()
                        if(searchModel.allIngredients.contains(searchModel.inputIngredient) && searchModel.inputIngredient != ""){
                            Button(action: {
                                myKeyborad = false
                                searchModel.addIngerdients(ingredient: searchModel.inputIngredient.lowercased())
                                searchModel.inputIngredient = ""
                                withAnimation {
                                    self.isShowing.toggle()
                                }
                            }) {
                                Text("confirm")
                            }
                        }
                    }
                }
                .padding()
                .background(color == .dark ? .gray : .white)
                .cornerRadius(10)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height * 1
                )
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

extension View {
    
    func textFieldAlertIngredient(mySearchModel: getSearchPage,
                        isShowing: Binding<Bool>,
                        title: String) -> some View {
        TextFieldAlertIngredient(searchModel: mySearchModel, isShowing: isShowing,
                       presenting: self,
                       title: title)
    }

}

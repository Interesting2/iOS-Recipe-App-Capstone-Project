//
//  SearchPage.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//  Edit By Andrew 29 Aug 2022
//

import SwiftUI

struct Category: Hashable {
    let id: Int
    var title: String
    var selected: Bool
    
    init (id: Int, title: String, selected: Bool) {
        self.id = id
        self.title = title
        self.selected = selected
    }
}

func searchBoxFontSize(_ offset : Int) -> Double {
    var fontsize = (15 - abs(Double(offset))*1.5)
    if fontsize < 9.0 {
        fontsize = 9.0
        print(fontsize)
    }
    return fontsize
}

struct SearchPage: View {
    
    @ObservedObject var searchModel:getSearchPage
    @Environment(\.colorScheme) var color
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    @State private var isIngredientShowingAlert = false
    @State private var isDislikeShowingAlert = false
    
    @State var isLinkActive = false
    @State var innerHidden = false
    
    //@State private var select = ""
    
    @State var navBarHidden: Bool = true
    //@State private var index = ""
    
    
    //let items = ["ALL","Steaming","Boiling","Pan-Frying"]
    
    
    @State var CalorieSelectedIndex = 0
    @State private var CalorieCurrentIndex: Int = 0
    
    @State var MethodSelectedIndex = 0
    @State private var MethodCurrentIndex: Int = 0
    
    @State var OrderSelectedIndex = 0
    @State private var OrderCurrentIndex: Int = 0
    
    @State var HandicapSelectedIndex = 0
    @State private var HandicapCurrentIndex: Int = 0
    
    @Namespace private var ns
    
    var OrderBy: [Category] = [Category(id: 0, title: "Popularity", selected: true),Category(id: 1, title: "Rating", selected: false),Category(id: 2, title: "Calorie", selected: false)]
    
    var Methods: [Category] = [Category(id: 0, title: "All", selected: true),Category(id: 1, title: "bake", selected: false),Category(id: 2, title: "barbecue", selected: false),Category(id: 3, title: "boil", selected: false),Category(id: 4, title: "cut", selected: true),Category(id: 5, title: "dessert", selected: false),Category(id: 6, title: "fry", selected: false),Category(id: 7, title: "grill", selected: false),Category(id: 8, title: "omelet", selected: true),Category(id: 9, title: "poaching", selected: false),Category(id: 10, title: "roast", selected: false),Category(id: 11, title: "simmering", selected: false),Category(id: 12, title: "steam", selected: true),Category(id: 13, title: "stew", selected: false) ]
    
    
    var Calories: [Category] = [Category(id: 0, title: "Any", selected: true),Category(id: 1, title: "100", selected: true),Category(id: 2, title: "200", selected: false),Category(id: 3, title: "300", selected: false),Category(id: 4, title: "400", selected: false),Category(id: 5, title: "500", selected: true),Category(id: 6, title: "600", selected: false),Category(id: 7, title: "700", selected: false),Category(id: 8, title: "800", selected: false),Category(id: 9, title: "900", selected: true),Category(id: 10, title: "1000", selected: false),Category(id: 11, title: "1100", selected: false),Category(id: 12, title: "1200", selected: false),Category(id: 13, title: "1300", selected: true),Category(id: 14, title: "1400", selected: false),Category(id: 15, title: "1500", selected: false),Category(id: 16, title: "1600", selected: false),Category(id: 17, title: "1700", selected: true),Category(id: 18, title: "1800", selected: false),Category(id: 19, title: "1900", selected: false),Category(id: 20, title: "2000", selected: false),Category(id: 21, title: "2100", selected: true),Category(id: 22, title: "2200", selected: false),Category(id: 23, title: "2300", selected: false),Category(id: 24, title: "2400", selected: false),Category(id: 25, title: "2500", selected: true),Category(id: 26, title: "2600", selected: false),Category(id: 27, title: "2700", selected: false),Category(id: 28, title: "2800", selected: false),Category(id: 29, title: "2900", selected: true),Category(id: 30, title: "3000", selected: false),Category(id: 31, title: "3100", selected: false),Category(id: 32, title: "3200", selected: false)]
    
    var handicap: [Category] = [Category(id: 0, title: "None ", selected: true),Category(id: 1, title: "Low sugar", selected: false),Category(id: 2, title: "Low Fat", selected: false),Category(id: 3, title: "High Protein", selected: true)]
    
    @State var blacklistRecipes : [String] = Storage.shared.retrieveBlacklist()

   
    
    var body: some View {
        NavigationView {    
            ScrollView(.vertical, showsIndicators: true){
                NavigationView {
                    List {
                        let myRating = setStarRating()
                        let myLikes = likeViewModel()
                        ForEach(searchModel.searchRecipiesResults, id: \.self) { name in
                            //TODO
                            //REWRITE this part to show the detail page correctly
                            if (!blacklistRecipes.contains(name)) {
                                NavigationLink(destination: SearchDetailPage(recipeName:name, blacklistRecipes: $blacklistRecipes, searchViewModel:searchModel,ratingViewModel: myRating, myLikeViewModel: myLikes)
                                .tabItem({
                                    Image(systemName: "menucard")
                                    Text("More")
                                })) {
                                    Text(name)
                                }
                            }
                            //                        }.simultaneousGesture(TapGesture().onEnded{
                            //                            searchModel.selectARecipe(recipeName: name)
                            //                        })
                        }
                    }
                    .searchable(text: $searchModel.searchText,prompt: "Enter Recipe Name")
                    .navigationTitle("Search")
                    .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                    
                    
                }.frame(height: searchModel.searchBarSize)
                .navigationBarHidden(self.navBarHidden)
                .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                
                //.aspectRatio(5/2, contentMode: .fit)
                if searchModel.searchText.isEmpty {
                    VStack{
                        HStack{
                            Text("Order by").bold()
                            Spacer()
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { scrollView in
                                    HStack(spacing: 35) {
                                        ForEach(OrderBy, id: \.self) { item in
                                            if item.id == OrderCurrentIndex {
                                                ZStack() {
                                                    Text(item.title)
                                                        .font(.system(size: 18))
                                                        .bold()
                                                        .layoutPriority(1)
                                                    VStack() {
                                                        Rectangle().frame(height: 2)
                                                            .padding(.top, 20)
                                                    }
                                                    .matchedGeometryEffect(id: "animation1", in: ns)
                                                }
                                            } else {
                                                Text(item.title)
                                                    .font(.system(size: CGFloat(searchBoxFontSize(Int(item.id) - Int(OrderCurrentIndex)))))
                                                    .onTapGesture {
                                                        withAnimation {
                                                            OrderCurrentIndex = item.id
                                                            OrderSelectedIndex = OrderCurrentIndex
                                                            searchModel.orderChoice = OrderCurrentIndex
                                                            scrollView.scrollTo(item)
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                    .padding(.trailing, 20)
                                }
                            }.frame(width: 250, height: 30).background(color == .dark ? .gray : .white).cornerRadius(5.0)
                                //.overlay(Rectangle().stroke(Color.black).cornerRadius(1))
                        }.padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        HStack{
                            Text("Max Calorie").bold()
                            Spacer()
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { scrollView in
                                    HStack(spacing: 32) {
                                        ForEach(Calories, id: \.self) { item in
                                            if item.id == CalorieCurrentIndex {
                                                ZStack() {
                                                    Text(item.title)
                                                        .font(.system(size: 18))
                                                        .bold()
                                                        .layoutPriority(1)
                                                    VStack() {
                                                        Rectangle().frame(height: 2)
                                                            .padding(.top, 20)
                                                    }
                                                    .matchedGeometryEffect(id: "animation2", in: ns)
                                                }
                                            } else {
                                                Text(item.title)
                                                    .font(.system(size: CGFloat(searchBoxFontSize(Int(item.id) - Int(CalorieCurrentIndex)))))
                                                    .onTapGesture {
                                                        withAnimation {
                                                            CalorieCurrentIndex = item.id
                                                            CalorieSelectedIndex = CalorieCurrentIndex
                                                            searchModel.calorieChoice = CalorieCurrentIndex
                                                            scrollView.scrollTo(item)
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                    .padding(.trailing, 20)
                                }
                            }.frame(width: 250, height: 30).background(color == .dark ? .gray : .white).cornerRadius(5.0)
                                //.overlay(Rectangle().stroke(Color.black).cornerRadius(1))
                            //Text("Value: \(calorieChoice)")
                        }.padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        HStack{
                            Text("Method").bold()
                            Spacer()
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { scrollView in
                                    HStack(spacing: 33) {
                                        ForEach(Methods, id: \.self) { item in
                                            if item.id == MethodCurrentIndex {
                                                ZStack() {
                                                    Text(item.title)
                                                        .font(.system(size: 18))
                                                        .bold()
                                                        .layoutPriority(1)
                                                    VStack() {
                                                        Rectangle().frame(height: 2)
                                                            .padding(.top, 20)
                                                    }
                                                    .matchedGeometryEffect(id: "animation3", in: ns)
                                                }
                                            } else {
                                                Text(item.title)
                                                    .font(.system(size: CGFloat(14 )))
                                                    .onTapGesture {
                                                        withAnimation {
                                                            MethodCurrentIndex = item.id
                                                            MethodSelectedIndex = MethodCurrentIndex
                                                            searchModel.methodChoice = MethodCurrentIndex
                                                            scrollView.scrollTo(item)
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                    .padding(.trailing, 20)
                                }
                            }.frame(width: 250, height: 30).background(color == .dark ? .gray : .white).cornerRadius(5.0)
                                //.overlay(Rectangle().stroke(Color.black).cornerRadius(1))
                            
                            //Text("Value: \(methodChoice)")
                        }.padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        
                        
                        
                        HStack{
                            Text("handicap").bold()
                            Spacer()
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { scrollView in
                                    HStack(spacing: 23.5) {
                                        ForEach(handicap, id: \.self) { item in
                                            if item.id == HandicapCurrentIndex {
                                                ZStack() {
                                                    Text(item.title)
                                                        .font(.system(size: 18))
                                                        .bold()
                                                        .layoutPriority(1)
                                                    VStack() {
                                                        Rectangle().frame(height: 2)
                                                            .padding(.top, 20)
                                                    }
                                                    .matchedGeometryEffect(id: "animation4", in: ns)
                                                }
                                            } else {
                                                Text(item.title)
                                                    .font(.system(size: CGFloat(14)))
                                                    .onTapGesture {
                                                        withAnimation {
                                                            HandicapCurrentIndex = item.id
                                                            HandicapSelectedIndex = HandicapCurrentIndex
                                                            searchModel.functionChoice = HandicapCurrentIndex
                                                            scrollView.scrollTo(item)
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.leading, 10)
                                    .padding(.trailing, 20)
                                }
                            }.frame(width: 250, height: 30).background(color == .dark ? .gray : .white).cornerRadius(5.0)
                                //.overlay(Rectangle().stroke(Color.black).cornerRadius(1))
                            
                            //Text("Value: \(functionChoice)")
                        }.padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        
                        Divider().frame(width: 360,height: 3)
                        
                        VStack{
                            HStack{
                                Text("Ingredient")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                
                                
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        self.isIngredientShowingAlert.toggle()
                                    }
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(/*@START_MENU_TOKEN@*/.all, 22.0/*@END_MENU_TOKEN@*/)
                            }
                            NavigationView {
                                if #available(iOS 16.0, *) {
                                    List {
                                        ForEach(searchModel.searchIngredients, id: \.self) { user in
                                            Text(user)
                                        }
                                        .onDelete(perform: searchModel.deleteIngredients)
                                    }
                                    .navigationTitle("Ingredients")
                                    .navigationBarHidden(true)
                                    .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                                    .scrollContentBackground(.hidden)
                                } else {
                                    // Fallback on earlier versions
                                    List {
                                        ForEach(searchModel.searchIngredients, id: \.self) { user in
                                            Text(user)
                                        }
                                        .onDelete(perform: searchModel.deleteIngredients)
                                    }
                                    .navigationTitle("Ingredients")
                                    .navigationBarHidden(true)
                                    .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                                }
                                
                            }
                        }.textFieldAlertIngredient(mySearchModel: searchModel, isShowing: $isIngredientShowingAlert, title: "enter a ingredient")
                            .frame(height: searchModel.ingredientSize)
                        Divider().frame(width: 360,height: 3)
                        VStack{
                            HStack{
                                Text("I don't like")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                
                                
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        self.isDislikeShowingAlert.toggle()
                                    }
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(/*@START_MENU_TOKEN@*/.all, 22.0/*@END_MENU_TOKEN@*/)
                            }
                            NavigationView {
                                if #available(iOS 16.0, *) {
                                    List {
                                        ForEach(searchModel.dislikeIngredients, id: \.self) { user in
                                            //                                            if(user != ""){
                                            //                                                Text(user)
                                            //                                            }
                                            Text(user)
                                        }
                                        .onDelete(perform: searchModel.deleteDislike)
                                    }
                                    .navigationTitle("I don't like")
                                    .navigationBarHidden(true)
                                    .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                                    .scrollContentBackground(.hidden)
                                } else {
                                    // Fallback on earlier versions
                                    List {
                                        ForEach(searchModel.dislikeIngredients, id: \.self) { user in
                                            //                                            if(user != ""){
                                            //                                                Text(user)
                                            //                                            }
                                            Text(user)
                                        }
                                        .onDelete(perform: searchModel.deleteDislike)
                                    }
                                    .navigationTitle("I don't like")
                                    .navigationBarHidden(true)
                                    .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                                }
                                
                            }
                            .textFieldAlertDislike(mySearchModel: searchModel, isShowing: $isDislikeShowingAlert, title: "enter a ingredient")
                            .frame(height: searchModel.dislikeSize)
                        }
                    }.edgesIgnoringSafeArea(.all)
                        .ignoresSafeArea(.all)
                }
                Spacer()
                if searchModel.searchText.isEmpty {
                    HStack{
                        Button("Clear", role: .destructive) {
                            CalorieSelectedIndex = 0
                            CalorieCurrentIndex = 0
                            
                            MethodSelectedIndex = 0
                            MethodCurrentIndex = 0
                            
                            OrderSelectedIndex = 0
                            OrderCurrentIndex = 0
                            
                            HandicapSelectedIndex = 0
                            HandicapCurrentIndex = 0
                            
                            searchModel.removeAllSearchIngredient()
                            searchModel.removeAllDislikeIngredient()
                            
                            searchModel.methodChoice = 0
                            searchModel.functionChoice = 0
                            searchModel.orderChoice = 0
                            searchModel.calorieChoice = 0
                            
                            
                        }
                            .padding([.leading, .bottom])
                            .buttonStyle(.borderedProminent)
                        Spacer()
                        VStack(alignment: .leading) {
                            NavigationLink(destination: SearchResultView(searchModel_: searchModel, blacklistRecipes_: $blacklistRecipes), isActive: $isLinkActive) {
                                Button(action: {
                                    searchModel.SearchByIngredients()
                                    self.isLinkActive = true
                                }) {
                                    Text("Search")
                                }.padding([.leading, .bottom, .trailing])
                                    .buttonStyle(.borderedProminent)
                            }
                        }
                        .navigationBarTitle(Text("Search"))
                        .navigationBarHidden(true)
                        
                    }
                }
                
            }.background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
                
                
        }.environmentObject(unitSelectionViewModel)
            .onAppear() {
                blacklistRecipes = Storage.shared.retrieveBlacklist()
                isLinkActive = false
                CalorieSelectedIndex = searchModel.calorieChoice
                CalorieCurrentIndex = searchModel.calorieChoice
                
                MethodSelectedIndex = searchModel.methodChoice
                MethodCurrentIndex = searchModel.methodChoice
                
                OrderSelectedIndex = searchModel.orderChoice
                OrderCurrentIndex = searchModel.orderChoice
                
                HandicapSelectedIndex = searchModel.functionChoice
                HandicapCurrentIndex = searchModel.functionChoice
            }
        
    }
    
}

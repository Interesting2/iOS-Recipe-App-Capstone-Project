//
//  TabBar.swift
//  Recipedia
//
//  This holds the four fundamental buttons on the bottom of the screen
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI

struct TabBar: View {
    @Namespace var animation
//    @Namespace var animation2
    @StateObject var detailObject = DetailPageViewModel()
    @StateObject var unitSelectionObject = UnitSelectionViewModel()
    
    @State var blacklistRecipes = Storage.shared.retrieveBlacklist()
    
    var body: some View {
        
            ZStack {
                TabView {
                    //Home Page
                    HomePage(animation: animation, blacklistRecipes: $blacklistRecipes)
                        .environmentObject(detailObject)
                        .environmentObject(unitSelectionObject)
                        .tabItem({
                            Image(systemName: "house")
                            Text("Home")
                        })
                    
                    //Search Page
                    let mySearchPage = getSearchPage()
                    let myRating = setStarRating()
                    SearchPage(searchModel: mySearchPage)
                        .environmentObject(unitSelectionObject)
                        .tabItem({
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        })
                    
                    //Saved Page
                    SavedPage()
//                        .environmentObject(detailObject)
                        .environmentObject(detailObject)
                        .environmentObject(unitSelectionObject)
                        .tabItem({
                            Image(systemName: "square.stack.3d.down.right")
                            Text("Saved")
                        })
                    
                    
                    //More Page
                    MorePage()
                        .environmentObject(unitSelectionObject)
                        .tabItem({
                            Image(systemName: "ellipsis")
                            Text("More")
                        })
                }.onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithDefaultBackground()
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
                .opacity(detailObject.show ? 0 : 1)
                if detailObject.show {
                    let myRating = setStarRating()
                    let myLikes = likeViewModel()
                    HomeDetailPage(detailPageViewModel: detailObject, animation: animation,ratingViewModel: myRating,blacklistRecipes: $blacklistRecipes, myLikeViewModel: myLikes).environmentObject(unitSelectionObject)
                }
                
            }
            
        }
        
        
        
        
    }


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

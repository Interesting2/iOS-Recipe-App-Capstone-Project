//
//  RecipediaApp.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct RecipediaApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
}

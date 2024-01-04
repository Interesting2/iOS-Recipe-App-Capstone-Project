//
//  HomePageCard.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import SwiftUI
import NukeUI

func shortDescriptionGenerator(_ description : String) -> String {
    let delimiter = "."
    let shortDescription = description.components(separatedBy: delimiter)
    return shortDescription[0]
}

func unitConverter (calorie : Int, unit : UnitSelectionViewModel) -> String {
    if unit.currentSelection == 0 {
        return "\(calorie)KJ"
    } else {
        var new_calorie = Double(calorie) * 0.23
        return String(format: "%.0f", new_calorie) + "Kcal"
    }
}

struct HomePageCard: View {
    var recipeDetail : RecipeDetail
    
    // getting environment scheme color
    @Environment(\.colorScheme) var color
    
    @EnvironmentObject var unitSelectionViewModel : UnitSelectionViewModel
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack{
            
            LazyImage(url: URL(string: recipeDetail.fullImagePath))
                .matchedGeometryEffect(id: recipeDetail.fullImagePath, in: animation)
                .aspectRatio(contentMode: .fill)
                
                
                
            HStack{
                VStack(alignment: .leading) {
                    Text(unitConverter(calorie: recipeDetail.calorie, unit: unitSelectionViewModel)) // should be determined by the sorting conditions in the settings.
                        .layoutPriority(200)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(recipeDetail.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text(shortDescriptionGenerator(recipeDetail.description))
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                Spacer()
            }
            .matchedGeometryEffect(id: recipeDetail.id, in: animation)
            .padding()
        }
        .background(color == .dark ? Color(red: 152/255, green: 152/255, blue: 157/255, opacity: 0.1) : Color(red: 243/255, green: 241/255, blue: 241/255, opacity: 1.0))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: color == .dark ? 0.6 : 0.2), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

//
//  RecipeDetail.swift
//  Recipedia
//
//  Created by Lawrence Wang on 23/8/2022.
//

import Foundation

//struct RecipeDetail : Identifiable {
//    var fullImagePath : String
//    var thumbnailPath : String
//    var name : String
//    var description : String
//    var methodSummary : String
//    var likes : Int
//    var kcals : String
//    var ratings : Double
//    var isSaved : Bool
//    var isLiked: Bool
//    var ingredients : [String]
//    var nutritions : [String]
//    var method : [String]
//    
//    var id: String
//}

struct RecipeDetail : Identifiable {
    var name: String
    var methodSummary: String
    var description: String
    var fullImagePath: String
    var thumbnailPath: String
    var ratings: Double
    var isSaved: Int
    var numberOfRatings: Int
    var likes: Int
    var calorie: Int
    var protein: Double
    var fat: Double
    var sugar: Double
    var ingredient: [String]
    var ingredientSummary: [String]
    var method: [String]
    var id: String
}
/*

func fetchRecipe() -> [RecipeDetail] {
    
    var recipeList : [RecipeDetail] = []
    let recipe = RecipeDetail(fullImagePath: "https://firebasestorage.googleapis.com/v0/b/foodworldtest-2f475.appspot.com/o/full_pic%2FBakedTofu.jpg?alt=media&token=e94af712-0251-40fd-b5a3-6904d53fb6a6",
                                    thumbnailPath: "https://firebasestorage.googleapis.com/v0/b/foodworldtest-2f475.appspot.com/o/thumbnail_pic%2FBakedTofu.jpg?alt=media&token=35cafef1-27ab-4d2a-a6ed-d3df7155e725",
                                    name: "Baked Tofu",
                                    description: "A spicy, fragrant peanut sauce reminiscent of the groundnut stews that are popular across West Africa anchors this recipe. Any protein would be lucky to be doused and marinated in it, but tofu soaks up the peanut sauce’s flavors and chars up nicely upon roasting. The tofu’s neutral flavor allows the other flavors in the dish to break through. Red miso and fish sauce provide umami, honey lends a subtle sweetness and the lime zest in the coconut rice brightens it all. Finished with pickled peppers and fresh sliced scallions, this dish comes together to make an exciting but quick weeknight dinner.",
                                    methodSummary: "Baking",
                                    likes: 89,
                                    kcals: "1812KJ",
                                    ratings: 3.5,
                                    isSaved: 0,
                                    isLiked: false,
                                    ingredients: ["2 tablespoons peanut or vegetable oil, plus more for brushing the pan and drizzling", "Kosher salt"],
                                    nutritions: ["fat: 200g","protein: 150g"],
                                    method: ["Heat the oven to 450 degrees and lightly brush a large rimmed sheet pan with oil.","In a small bowl, stir 4 tablespoons lime juice with ½ teaspoon salt until salt dissolves. Add the sliced peppers, a few cracks of black pepper and set aside."],
                                    id: "zPRNTyLOgOdTz398DMlZ"
                                    )
    
    
    
    recipeList.append(recipe)

    return recipeList
}
   

*/

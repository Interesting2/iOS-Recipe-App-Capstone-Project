//
//  RatingModel.swift
//  HelloWorld
//
//  Created by Andrew Hou on 22/8/2022.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

struct starRating{
    
    
    var rating:Int
    var averageRating:Double
    var ratingNumbers:Int
    
    
    init(){
        rating = 0
        averageRating = 4.0
        ratingNumbers=1
    }
    
    
    
    mutating func setRating(index: Int){
        rating = index
        ratingNumbers += 1
        averageRating = (averageRating * Double( ratingNumbers - 1) + Double(rating)) / Double(ratingNumbers)
    }
    
    mutating func setAverageRating(index: Double){
        averageRating = index
    }
    
    
    
}

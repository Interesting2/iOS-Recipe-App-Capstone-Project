//
//  LikeModel.swift
//  Recipedia
//
//  Created by Andrew Hou on 18/10/2022.
//

import Foundation
struct LikeModel{

    var likes:Int
    var isLiked:Bool
    //var haveSet:Bool

    init(){
        likes = 0
        isLiked = false
        //haveSet = false
    }

    mutating func setLike(){
        if (isLiked) {
            likes -= 1
        } else {
            likes += 1
        }
        isLiked = !isLiked
    }

}

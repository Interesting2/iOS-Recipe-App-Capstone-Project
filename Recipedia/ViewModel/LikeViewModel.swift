//
//  LikeViewModel.swift
//  Recipedia
//
//  Created by Andrew Hou on 18/10/2022.
//

import SwiftUI
import Firebase

class likeViewModel: ObservableObject{
    @Published private(set) var model: LikeModel = LikeModel()
    
    func getLikes(RecipeID:String) -> Int{
        getLikesFromDB(myRecipeID:RecipeID)
        return model.likes
    }
    
    var isLiked: Bool{
        return model.isLiked
    }
    
    var getPureLikes:Int{
        return model.likes
    }
    
    func setLikes(RecipeID:String){
        getLikesFromDB(myRecipeID:RecipeID)
        model.setLike()
        setLikesDB(myRecipeID:RecipeID)
    }
    
    func getLikesFromDB(myRecipeID:String){
        let db = Firestore.firestore()
        
        let docRef = db.collection("Recipes").document(myRecipeID)
        print("test1")
        print(myRecipeID)
        print("test1")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                guard let data = document.data() else {
                  print("Document data was empty.")
                  return
                }
                //print("Current data: \(data["ratingNumbers"]as? Int ?? 0)")
                self.model.likes = data["likes"]as? Int ?? 0
                print(self.model.likes)
                print("test1")
            } else {
                print("Document does not exist")
            }
        }
        
        
        // Force the SDK to fetch the document from the cache. Could also specify
        // FirestoreSource.server or FirestoreSource.default.
//        let listener = db.collection("Recipes").document(myRecipeID)
//            .addSnapshotListener { documentSnapshot, error in
//              guard let document = documentSnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//              }
//              guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//              }
//                //print("Current data: \(data["ratingNumbers"]as? Int ?? 0)")
//                self.model.likes = data["likes"]as? Int ?? 0
//            }
        //listener.remove()
    }
    
    func setLikesDB(myRecipeID:String){
        let db = Firestore.firestore()
        
        let docRef = db.collection("Recipes").document(myRecipeID)
        if(model.isLiked){
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    try sfDocument = transaction.getDocument(docRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                guard let oldNumberRating = sfDocument.data()?["likes"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }

                // Note: this could be done without a transaction
                //       by updating the population using FieldValue.increment()
                
                
                transaction.updateData(["likes":  oldNumberRating + 1], forDocument: docRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
        }
        else{
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    try sfDocument = transaction.getDocument(docRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                guard let oldNumberRating = sfDocument.data()?["likes"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }

                // Note: this could be done without a transaction
                //       by updating the population using FieldValue.increment()
                
                
                transaction.updateData(["likes":  oldNumberRating - 1], forDocument: docRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
        }
    }
    
    
}

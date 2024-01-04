//
//  RatingViewModel.swift
//  HelloWorld
//
//  Created by Andrew Hou on 22/8/2022.
//

import SwiftUI
import Firebase

class setStarRating: ObservableObject{
    @Published private(set) var model: starRating = starRating()
    var RatingDB: Double = 0.0
    
    var getRating: Int{
        //getRatingFromDB()
        return model.rating
    }
    
    func getAverageRating(RecipeID:String) -> Double{
        getRatingFromDB(myRecipeID:RecipeID)
        return model.averageRating
    }
    
    func setRating(index: Int, RecipeID:String){
        getNumbersFromDB(myRecipeID:RecipeID)
        getRatingFromDB(myRecipeID:RecipeID)
        model.setRating(index: index)
        setNumberRatingDB(index: index,myRecipeID:RecipeID)
    }
    
    func getRatingFromDB(myRecipeID:String){
        let db = Firestore.firestore()
        let docRef = db.collection("Recipes").document(myRecipeID)
        // Force the SDK to fetch the document from the cache. Could also specify
        // FirestoreSource.server or FirestoreSource.default.
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                guard let data = document.data() else {
                  print("Document data was empty.")
                  return
                }
                //print("Current data: \(data["ratingNumbers"]as? Int ?? 0)")
                self.model.averageRating = data["ratings"]as? Double ?? 0.0
            } else {
                print("Document does not exist")
            }
        }
        
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
//                self.model.averageRating = data["ratings"]as? Double ?? 0.0
//            }
//        listener.remove()
    }
    
    func getNumbersFromDB(myRecipeID:String){
        let db = Firestore.firestore()
        
        // Force the SDK to fetch the document from the cache. Could also specify
        // FirestoreSource.server or FirestoreSource.default.
        
        let docRef = db.collection("Recipes").document(myRecipeID)
        docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        guard let data = document.data() else {
                          print("Document data was empty.")
                          return
                        }
                        //print("Current data: \(data["ratingNumbers"]as? Int ?? 0)")
                        self.model.ratingNumbers = data["numberOfRatings"]as? Int ?? 0
                    } else {
                        print("Document does not exist")
                    }
                }
//        let listener = db.collection("Recipes").document(myRecipeID)
//                    .addSnapshotListener { documentSnapshot, error in
//                      guard let document = documentSnapshot else {
//                        print("Error fetching document: \(error!)")
//                        return
//                      }
//                      guard let data = document.data() else {
//                        print("Document data was empty.")
//                        return
//                      }
//                        //print("Current data: \(data["ratingNumbers"]as? Int ?? 0)")
//                        self.model.ratingNumbers = data["numberOfRatings"]as? Int ?? 0
//                    }
//        //print(self.numberRatingDB)
        //listener.remove()
    }
    
    func setNumberRatingDB(index: Int,myRecipeID:String){
        let db = Firestore.firestore()
        
        let docRef = db.collection("Recipes").document(myRecipeID)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(docRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldNumberRating = sfDocument.data()?["numberOfRatings"] as? Int else {
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
            
            
            transaction.updateData(["numberOfRatings":  oldNumberRating + 1], forDocument: docRef)
            transaction.updateData(["ratings":  (self.model.averageRating * Double( self.model.ratingNumbers) + Double(index)) / Double(self.model.ratingNumbers+1)], forDocument: docRef)
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

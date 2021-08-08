//
//  FcollectionReference.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 8/8/21.
//

import Foundation
import Firebase

enum FcollectionReference:String{
    case User
}

func firebaseReference(_ collectionReference:FcollectionReference)->CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

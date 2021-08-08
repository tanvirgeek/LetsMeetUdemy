//
//  FirebaseListener.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 8/8/21.
//

import Foundation
import Firebase

class FirebaseListener{
    static let shared = FirebaseListener()
    private init(){}
    
    //MARK:- download FUser
    func downLoadCurrentUserFromFirebase(userId:String, email:String){
        firebaseReference(.User).document(userId).getDocument { (snapShot, downloadError) in
            if let snapShot = snapShot{
                if snapShot.exists{
                    //save user locally
                    let user = FUser(_dictionary: snapShot.data() as! NSDictionary)
                    user.saveUserLocally()
                }else{
                    // FirstLogin
                    if let user = k.userDefaults.object(forKey: k.currentUser){
                        FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                    }
                }
            }
        }
    }
}

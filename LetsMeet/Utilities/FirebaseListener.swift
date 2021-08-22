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
    var query:Query = firebaseReference(.User).limit(to: 4)
    var documents = [QueryDocumentSnapshot]()
    var reachedLast = false
    var reachedLastCalls = 0
    var newDataArrived = 0
    private init(){}
    
    //MARK:- download FUser
    func downLoadCurrentUserFromFirebase(userId:String, email:String){
        firebaseReference(.User).document(userId).getDocument { (snapShot, downloadError) in
            if let snapShot = snapShot{
                if snapShot.exists{
                    //save user locally
                    let user = FUser(_dictionary: snapShot.data() as! NSDictionary)
                    user.saveUserLocally()
                    user.getUserAvatarFromFireStore { (didset) in
                        
                    }
                }else{
                    // FirstLogin
                    if let user = k.userDefaults.object(forKey: k.currentUser){
                        FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                    }
                }
            }
        }
    }
    
    func downloadUserWith(userId:String,completion:@escaping (_ error:Error?, _ user:FUser?)->Void){
        firebaseReference(.User).document(userId).getDocument { (snapShot, downLoadError) in
            if let error = downLoadError{
                print(error.localizedDescription)
                completion(downLoadError,nil)
            }
            if let snap = snapShot{
                if snap.exists{
                    let user = FUser(_dictionary: snap.data()! as NSDictionary)
                    completion(nil,user)
                }else{
                    print("NO USER AVAILABLE")
                    completion(nil,nil)
                }
            }
        }
    }
    
    
    func getUserCardsFromFirebase(completion:@escaping (_ error:Error?,_ cards:[UserCardModel]?)->Void){
        var cards = [UserCardModel]()
        query.getDocuments { (snap, getDocumentsError) in
            if let error = getDocumentsError{
                print(error)
                completion(getDocumentsError, nil)
            }else{
                guard let documentsSnap = snap?.documents else{return}
                cards = documentsSnap.map { document -> UserCardModel in
                    let data = document.data()
                    let username = data[k.username] as? String ?? ""
                    let profession = data[k.profession] as? String ?? ""
                    let dateOfBirdth = data[k.dateOfBirth] as? Date ?? Date()
                    let avatarLink = data[k.avatarLink] as? String ?? ""
                    let objectId = data[k.objectId] as? String ?? ""
                    self.documents += [document]
                    return UserCardModel(objectId: objectId, username: username, dateOfBirth: dateOfBirdth, profession: profession, avatarLink: avatarLink)
                }
                completion(nil,cards)
            }
        }
    }
    
    func paginate(lastObjectId:String,completion:@escaping (_ error:Error?,_ cards:[UserCardModel]?)->Void) {
        
        //This line is the main pagination code.
        //Firestore allows you to fetch document from the last queryDocument
        //print("document:\(documents.last![k.username])")
        if reachedLast{
            print("ObjectID FromSnapShot:",documents.last![k.objectId] as! String)
            print("ObjectID From Table View:",lastObjectId)
            print("Same data")
            reachedLastCalls += 1
            print("reachedLastCalls:",reachedLastCalls)
        }else{
            self.query = query.start(afterDocument: documents.last!)
            print("Query:\(query)")
            getUserCardsFromFirebase { (error, cards) in
                
                if self.documents.last![k.objectId] as! String == lastObjectId {
                    self.reachedLast = true
                    print("reachedLast",self.reachedLast)
                }
                completion(error,cards)
                self.newDataArrived += 1
                print("newDataArived",self.newDataArrived)
            }
        }
        
    }
}

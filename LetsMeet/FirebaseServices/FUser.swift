//
//  FUser.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 5/8/21.
//

import Foundation
import Firebase

class FUser:Equatable{
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId:String
    var email:String
    var userName:String
    var dateOfBirth:Date
    var isMale:Bool
    var avatar:UIImage?
    var profession:String
    var jobTitle:String
    var about:String
    var city:String
    var country:String
    var height:Double
    var lookingfor:String
    var avatarLink:String
    
    var likedArray:[String]?
    var imageLinks:[String]?
    let registeredDate = Date()
    var pushId : String?
    
    var userDictionary:NSDictionary{
        return NSDictionary(objects: [
                                    self.objectId,
                                    self.email,
                                    self.userName,
                                    self.dateOfBirth,
                                    self.isMale,
                                    self.profession,
                                    self.jobTitle,
                                    self.about,
                                    self.city,
                                    self.country,
                                    self.height,
                                    self.lookingfor,
                                    self.avatarLink,
                                    self.likedArray ?? [],
                                    self.imageLinks ?? [],
                                    self.registeredDate,
                                    self.pushId ?? ""
            
            ], forKeys: [
                                    k.objectId as NSCopying,
                                    k.email as NSCopying,
                                    k.username as NSCopying,
                                    k.dateOfBirth as NSCopying,
                                    k.isMale as NSCopying,
                                    k.profession as NSCopying,
                                    k.jobTitle as NSCopying,
                                    k.about as NSCopying,
                                    k.city as NSCopying,
                                    k.country as NSCopying,
                                    k.height as NSCopying,
                                    k.lookingfor as NSCopying,
                                    k.avatarLink as NSCopying,
                                    k.likedArray as NSCopying,
                                    k.imageLinks as NSCopying,
                                    k.registerDate as NSCopying,
                                    k.pushId as NSCopying
            ])
    }
    
    //MARK:- init
    init(_objectId:String, _email:String, _userName:String, _dateOfBirth:Date, _isMale:Bool, _city:String, _avatarLink:String = ""){
        self.objectId = _objectId
        self.email = _email
        self.userName = _userName
        self.isMale = _isMale
        self.dateOfBirth = _dateOfBirth
        self.city = _city
        self.avatarLink = _avatarLink
        self.profession = ""
        self.jobTitle = ""
        self.about = ""
        self.country = ""
        self.height = 0.0
        self.lookingfor = ""
        self.likedArray = []
        self.imageLinks = []
    }
    
    init(_dictionary:NSDictionary){
        self.objectId = _dictionary[k.objectId] as? String ?? ""
        self.email = _dictionary[k.email] as? String ?? ""
        self.userName = _dictionary[k.username] as? String ?? ""
        self.isMale = _dictionary[k.isMale] as? Bool ?? true
        self.city = _dictionary[k.city] as? String ?? ""
        self.avatarLink = _dictionary[k.avatarLink] as? String ?? ""
        self.profession = _dictionary[k.profession] as? String ?? ""
        self.jobTitle = _dictionary[k.jobTitle] as? String ?? ""
        self.about = _dictionary[k.about] as? String ?? ""
        self.country = _dictionary[k.country] as? String ?? ""
        self.height = _dictionary[k.height] as? Double ?? 0.0
        self.lookingfor = _dictionary[k.lookingfor] as? String ?? ""
        self.likedArray = _dictionary[k.likedArray] as? [String]
        self.imageLinks = _dictionary[k.imageLinks] as? [String]
        
        if let date = _dictionary[k.dateOfBirth] as? Timestamp{
            self.dateOfBirth = date.dateValue()
        }else{
            self.dateOfBirth = _dictionary[k.dateOfBirth] as? Date ?? Date()
        }
        
    }
    
    //MARK:- Returning Current User
    class func currentUserId()->String?{
        return Auth.auth().currentUser?.uid
    }
    class func currentUser()->FUser?{
        if currentUserId() != nil{
            if let userDictionary = k.userDefaults.object(forKey: k.currentUser){
                return FUser(_dictionary: userDictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    
    //MARK:- Login
    class func loginWith(email:String, password:String, completion:@escaping (_ error:Error?, _ isEmailVerified:Bool)->Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error{
                completion(error,false)
            }else if let signInResult = authResult{
                if signInResult.user.isEmailVerified{
                    //check if user exists in firebase
                    FirebaseListener.shared.downLoadCurrentUserFromFirebase(userId: signInResult.user.uid, email: email)
                    completion(error,true)
                }else{
                    completion(error, false)
                    print("email not verified")
                }
            }
        }
        
    }
    
    //MARK:- Register
    class func registerUserWith(email:String,password:String,username:String,city:String,isMale:Bool,dateOfBirth:Date, completion:@escaping (_ error:Error?)->Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, authError) in
            
            
            if let error = authError{
                completion(authError)
                print(error.localizedDescription)
            }else{
                if let authData = authData{
                    authData.user.sendEmailVerification { (emailVarificationError) in
                        if let error = emailVarificationError{
                            completion(emailVarificationError)
                            print(error.localizedDescription)
                        }else{
                            print("Auth email verification sent")
                            completion(emailVarificationError)
                            let user = FUser(_objectId: authData.user.uid, _email: email, _userName: username, _dateOfBirth: dateOfBirth, _isMale: isMale, _city: city)
                            
                            user.saveUserLocally()
                        }
                    }
                }
            }
        }
        
    }
    
    //MARK:- resetPassword
    class func resetPasswordFor(email:String, completion:@escaping(_ error:Error?)->Void){
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
        
    }
    
    func saveUserLocally(){
        k.userDefaults.setValue(self.userDictionary as! [String:Any], forKey: k.currentUser)
        k.userDefaults.synchronize()
    }
    
    func saveUserToFireStore(){
        firebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]){ error in
            
            if let error = error{
                print("Saving user to fireStore error: \(error.localizedDescription)")
            }else{
                print("Data saved to Firestore")
            }
        }
    }
    
}

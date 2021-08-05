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
    
    let objectId:String = ""
    
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
                        }
                    }
                }
            }
        }
        
    }
}

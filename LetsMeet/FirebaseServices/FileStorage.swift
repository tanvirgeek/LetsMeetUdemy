//
//  FileStorage.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 13/8/21.
//

import Foundation
import FirebaseStorage




class FileStorage{
    class func uploadImage(_ image:UIImage, directory:String, completion: @escaping (_ documentLink:String?)->Void){
        let storageRef = Storage.storage().reference().child(directory)
        guard let imageData = image.jpegData(compressionQuality: 0.6)else {return}
        var task:StorageUploadTask!
        task = storageRef.putData(imageData, metadata: nil, completion: { (metaData, imageUploadingError) in
            task.removeAllObservers()
            if let error = imageUploadingError{
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
            }else{
                storageRef.downloadURL { (url, erro) in
                    guard let downLoadUrl = url else
                    {
                        completion(nil)
                        return
                    }
                    print("We have uploaded image to \(downLoadUrl.absoluteString)")
                    completion(downLoadUrl.absoluteString)
                }
            }
        })
    }
}

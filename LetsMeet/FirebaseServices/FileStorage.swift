//
//  FileStorage.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 13/8/21.
//

import Foundation
import FirebaseStorage




class FileStorage{
    
    class func downloadImage(imageURL:String, completion:@escaping(_ image:UIImage?)->Void){
        //let imageFileNameCurrentUser = FUser.currentUserId()
        let imageFileName = imageURL.components(separatedBy: "_").last!.components(separatedBy: "?").first!.components(separatedBy: ".").first!
        
        if fileExistsAtPath(path: imageFileName){
            print("We have local file")
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)){
                completion(contentsOfFile)
            }else{
                print("Could not generate Image from local Image")
                completion(nil)
            }
        }else{
            // Download
            print("Downloading")
            if imageURL != ""{
                let documentURL = URL(string: imageURL)
                let downloadQueue = DispatchQueue(label: "downloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    if let data = data {
                        let imagetoReturn = UIImage(data: data as Data)
                        FileStorage.saveImageLocally(imageData: data, fileName: imageFileName)
                        completion(imagetoReturn)
                    }else{
                        print("No image in database")
                        completion(nil)
                    }
                }
            }else{
                completion(nil)
            }
        }
        
    }
    
    
    class func downloadImages(imageURLs:[String], completion:@escaping(_ images:[UIImage?])->Void){
        var imageArray : [UIImage] = []
        var downloadCounter = 0
        for link in imageURLs{
            let url = NSURL(string: link)
            
            let downloadQueue = DispatchQueue(label: "downloadQueue")
            downloadQueue.async {
                
                downloadCounter += 1
                let data = NSData(contentsOf: url! as URL)
                if let data = data {
                    if let image = UIImage(data: data as Data){
                        imageArray.append(image)
                        if downloadCounter == imageURLs.count{
                            completion(imageArray)
                        }
                    }
                }else{
                    print("No image in database")
                    completion(imageArray)
                }
            }
        }
    }
    
    
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
    
    class func uploadImages(_ images:[UIImage?],completion: @escaping (_ documentLinks:[String])->Void){
        
        var uploadImageCount = 0
        var imageLinkArray:[String] = []
        var nameSuffix = 0
        
        for image in images{
            let fileDirectory = "UserImages/" + FUser.currentUserId()! + "/" + "\(nameSuffix)" + ".jpg"
            if let image = image{
                uploadImage(image, directory: fileDirectory) { (imageLink) in
                    if let imageLink = imageLink{
                        imageLinkArray.append(imageLink)
                        uploadImageCount += 1
                        
                        if uploadImageCount == images.count{
                            completion(imageLinkArray)
                        }
                    }
                }
            }
            nameSuffix += 1
        }
    }
    
    class func saveImageLocally(imageData:NSData, fileName:String){
        var docURL = getDocumentsURL()
        
        docURL = docURL.appendingPathComponent(fileName,isDirectory: false)
        imageData.write(to: docURL, atomically: true)
    }
}

func getDocumentsURL() -> URL{
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    return documentURL!
}

func fileInDocumentsDirectory(fileName:String) -> String{
    let fileURL = getDocumentsURL().appendingPathComponent(fileName)
    return fileURL.path
}

func fileExistsAtPath(path:String)->Bool{
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}

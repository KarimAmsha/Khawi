//
//  FirestoreService.swift
//  Khawi
//
//  Created by Karim Amsha on 11.02.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import FirebaseStorage
import UIKit

class FirestoreService {
    static let shared = FirestoreService()
    let imageStorage = Storage.storage().reference().child("images") // Assuming "images" is your Firebase Storage bucket
    
    private init() {}
    
    // Upload Image
    func uploadImageWithThumbnail(image: UIImage?, id: String, imageName: String, completion: @escaping(String?, Bool)->Void) {
        guard let image = image,
              let uploadData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil, false)
            return
        }
        
        let storedImage = imageStorage.child(id).child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storedImage.putData(uploadData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil, false)
            } else {
                storedImage.downloadURL { (url, error) in
                    if let downloadURL = url?.absoluteString {
                        completion(downloadURL, true)
                    } else {
                        completion(nil, false)
                    }
                }
            }
        }
    }
    
    // Upload Multi Images
    func uploadMultipleImages(images: [UIImage?], id: String, completion: @escaping ([String]?, Bool) -> Void) {
        var uploadedImageUrls: [String] = []
        var uploadCount = 0
        
        guard !images.isEmpty else {
            completion([], false)
            return
        }
        
        for (index, image) in images.enumerated() {
            var imageName = ""
            switch index {
                case 0: imageName = "profile"
                case 1: imageName = "carFront"
                case 2: imageName = "carBack"
                case 3: imageName = "carRight"
                case 4: imageName = "carLeft"
                case 5: imageName = "identity"
                case 6: imageName = "license"
                default: break
            }
            
            uploadImageWithThumbnail(image: image, id: id, imageName: imageName) { (url, success) in
                uploadCount += 1
                
                if let url = url {
                    uploadedImageUrls.append(url)
                }
                
                if uploadCount == images.count {
                    completion(uploadedImageUrls, true)
                } else if !success {
                    completion(nil, false)
                }
            }
        }
    }
}

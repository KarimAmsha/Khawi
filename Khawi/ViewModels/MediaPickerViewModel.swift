//
//  MediaPickerViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI

class MediaPickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var selectedImageLastPath: String?
    @Published var selectedIDImage: UIImage?
    @Published var selectedIDImageLastPath: String?
    @Published var selectedLicanseImage: UIImage?
    @Published var selectedLicanseImageLastPath: String?
    @Published var isPresentingImagePicker = false
    @Published var isPresentingIDImagePicker = false
    @Published var isPresentingLicanseImagePicker = false
    private(set) var sourceType: ImagePicker.SourceType = .camera

    func choosePhoto() {
        sourceType = .photoLibrary
        isPresentingImagePicker = true
    }
    
    func takePhoto() {
        sourceType = .camera
        isPresentingImagePicker = true
    }
    
    func chooseIDPhoto() {
        sourceType = .photoLibrary
        isPresentingIDImagePicker = true
    }
    
    func takeIDPhoto() {
        sourceType = .camera
        isPresentingIDImagePicker = true
    }
    
    func chooseLicensePhoto() {
        sourceType = .photoLibrary
        isPresentingLicanseImagePicker = true
    }
    
    func takeLicensePhoto() {
        sourceType = .camera
        isPresentingLicanseImagePicker = true
    }

    func chooseVideo() {
        sourceType = .photoLibrary
        isPresentingImagePicker = true
    }
    
    func didSelectImage(_ image: UIImage?, _ lastPath: String?) {
        selectedImage = image
        selectedImageLastPath = lastPath
        isPresentingImagePicker = false
        
    }
    
    func didSelectIDImage(_ image: UIImage?, _ lastPath: String?) {
        selectedIDImage = image
        selectedIDImageLastPath = lastPath
        isPresentingIDImagePicker = false
    }
    
    func didSelectLicanseImage(_ image: UIImage?, _ lastPath: String?) {
        selectedLicanseImage = image
        selectedLicanseImageLastPath = lastPath
        isPresentingLicanseImagePicker = false
    }
}

class MediaViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var selectedVideoUrl: URL?
    @Published var isPresentingMediaPicker = false
    private(set) var sourceType: MediaPicker.SourceType = .camera
    var mediaType: MediaPicker.MType = .image

    func choosePhoto() {
        sourceType = .photoLibrary
        mediaType = .image
        isPresentingMediaPicker = true
    }
    
    func takePhoto() {
        sourceType = .camera
        mediaType = .image
        isPresentingMediaPicker = true
    }
    
    func chooseVideo() {
        sourceType = .photoLibrary
        mediaType = .video
        isPresentingMediaPicker = true
    }
    
    func didSelectImage(_ image: UIImage?) {
        selectedImage = image
        isPresentingMediaPicker = false
    }
    
    func didSelectVideo(_ url: URL?) {
        selectedVideoUrl = url
        selectedImage = url?.getThumbnailFrom()
        isPresentingMediaPicker = false
    }
}

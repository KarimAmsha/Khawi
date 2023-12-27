//
//  EditProfileView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import PopupView
import MapKit

struct EditProfileView: View {
    @StateObject var mediaPickerViewModel = MediaPickerViewModel()
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var hasCar = false
    @State private var carType = ""
    @State private var carModel = ""
    @State private var carColor = ""
    @State private var carNumber = ""
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    private let errorHandling = ErrorHandling()
    @StateObject private var viewModel = UserViewModel(errorHandling: ErrorHandling())
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var isFloatingPickerPresented = false
    @State private var isFloatingCarFrontImagePickerPresented = false
    @State private var isFloatingCarBackImagePickerPresented = false
    @State private var isFloatingCarRightImagePickerPresented = false
    @State private var isFloatingCarLeftImagePickerPresented = false
    @State private var isFloatingIdentityImagePickerPresented = false
    @State private var isFloatingLicenseImagePickerPresented = false
    @StateObject private var authViewModel = AuthViewModel(errorHandling: ErrorHandling())

    private var isImageSelected: Bool {
        mediaPickerViewModel.selectedImage != nil
    }
    
    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ZStack {
                            if let img = mediaPickerViewModel.selectedImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                AsyncImage(url: viewModel.user?.image?.toURL()) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView() // Placeholder while loading
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle()) // Clip the image to a circle
                                    case .failure:
                                        Image(systemName: "photo.circle") // Placeholder for failure
                                            .resizable()
                                            .imageScale(.large)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 120, height: 120)
                            }
                            
                            // Button with image at the bottom-right corner
                            Button(action: {
                                isFloatingPickerPresented.toggle()
                            }) {
                                Image("ic_camera")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                            }
                            .background(Circle().fill(Color.primary()))
                            .frame(width: 40, height: 40)
                            .offset(x: -40, y: 40)
                            .disabled(viewModel.isLoading)
                        }
                        
                        VStack(spacing: 16) {
                            CustomTextFieldWithTitle(text: $name, placeholder: LocalizedStringKey.fullName, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .disabled(viewModel.isLoading)
                            CustomTextFieldWithTitle(text: $phone, placeholder: LocalizedStringKey.phoneNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .keyboardType(.phonePad)
                                .disabled(true)
                            CustomTextFieldWithTitle(text: $email, placeholder: LocalizedStringKey.email, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .keyboardType(.emailAddress)
                                .disabled(viewModel.isLoading)
                        }
                        .padding(.top, 12)
                        
                        Button {
                            withAnimation {
                                hasCar.toggle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: hasCar ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(hasCar ? .primary() : .grayDDDFDF())
                                Text(LocalizedStringKey.areYouHaveCar)
                                    .customFont(weight: .book, size: 16)
                                    .foregroundColor(.black131313())
                                Spacer()
                            }
                        }
                        .disabled(viewModel.isLoading)
                        
                        if hasCar {
                            VStack(spacing: 16) {
                                CustomTextFieldWithTitle(text: $carType, placeholder: LocalizedStringKey.carType, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                CustomTextFieldWithTitle(text: $carModel, placeholder: LocalizedStringKey.carModel, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                CustomTextFieldWithTitle(text: $carColor, placeholder: LocalizedStringKey.carColor, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                CustomTextFieldWithTitle(text: $carNumber, placeholder: LocalizedStringKey.carNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        createImageSection(image: mediaPickerViewModel.selectedCarFrontImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarFrontImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carFrontImage,
                                                           imageURL: viewModel.user?.carFrontImage?.toURL())

                                        Spacer()

                                        createImageSection(image: mediaPickerViewModel.selectedCarBackImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarBackImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carBackImage,
                                                           imageURL: viewModel.user?.carBackImage?.toURL())
                                    }

                                    HStack(spacing: 16) {
                                        createImageSection(image: mediaPickerViewModel.selectedCarRightImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarRightImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carRightImage,
                                                           imageURL: viewModel.user?.carRightImage?.toURL())

                                        Spacer()

                                        createImageSection(image: mediaPickerViewModel.selectedCarLeftImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarLeftImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carLeftImage,
                                                           imageURL: viewModel.user?.carLeftImage?.toURL())
                                    }

                                    HStack(spacing: 16) {
                                        createImageSection(image: mediaPickerViewModel.selectedIDImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingIdentityImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.identityImage,
                                                           imageURL: viewModel.user?.identityImage?.toURL())

                                        Spacer()

                                        createImageSection(image: mediaPickerViewModel.selectedLicanseImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingLicenseImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.licenseImage,
                                                           imageURL: viewModel.user?.licenseImage?.toURL())
                                    }
                                }
                            }
                        }

                        Spacer()
                        
                        if let uploadProgress = viewModel.uploadProgress {
                            // Display the progress view only when upload is in progress
                            LinearProgressView(LocalizedStringKey.loading, progress: uploadProgress, color: .primary())
                        }

                        Button {
                            update()
                        } label: {
                            Text(LocalizedStringKey.saveChanges)
                        }
                        .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                        .disabled(viewModel.isLoading)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }        
        .dismissKeyboard()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.profile)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectImage)
        })
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingCarFrontImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectCarFrontImage)
        })
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingCarBackImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectCarBackImage)
        })
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingCarRightImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectCarRightImage)
        })
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingCarLeftImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectCarLeftImage)
        })
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingIDImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectIDImage)
        })
        .fullScreenCover(isPresented: $mediaPickerViewModel.isPresentingLicanseImagePicker, content: {
            ImagePicker(sourceType: mediaPickerViewModel.sourceType, completionHandler: mediaPickerViewModel.didSelectLicanseImage)
        })
        .popup(isPresented: $isFloatingPickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingPickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.choosePhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takePhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $isFloatingCarFrontImagePickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingCarFrontImagePickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.chooseCarFrontPhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takeCarFrontPhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $isFloatingCarBackImagePickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingCarBackImagePickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.chooseCarBackPhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takeCarBackPhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $isFloatingCarRightImagePickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingCarRightImagePickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.chooseCarRightPhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takeCarRightPhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $isFloatingCarLeftImagePickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingCarLeftImagePickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.chooseCarLeftPhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takeCarLeftPhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $isFloatingIdentityImagePickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingIdentityImagePickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.chooseIDPhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takeIDPhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $isFloatingLicenseImagePickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingLicenseImagePickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickerViewModel.chooseLicensePhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickerViewModel.takeLicensePhoto()
                }
            )
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
        }
        .onAppear {
            getUserData()
            // Use the user's current location if available
            if let userLocation = LocationManager.shared.userLocation {
                self.userLocation = userLocation
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
            }
        }
    }
    
    private func createImageSection(image: UIImage?, placeholder: String, action: @escaping () -> Void, title: String, imageURL: URL?) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(weight: .book, size: 16)
                .foregroundColor(.grayA4ACAD())
            
            Button(action: action) {
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                } else {
                    if let userImageURL = imageURL {
                        AsyncImage(url: userImageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .background(Color.grayF9FAFA())
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.grayE6E9EA(), lineWidth: 1)
                                    )
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                                    .frame(width: 120, height: 120)
                                    .background(Color.grayF9FAFA())
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.grayE6E9EA(), lineWidth: 1)
                                    )
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        // Use a default placeholder for cases where the image URL is not available
                        Image(systemName: placeholder)
                            .resizable()
                            .imageScale(.large)
                            .foregroundColor(.gray)
                            .frame(width: 120, height: 120)
                            .background(Color.grayF9FAFA())
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.grayE6E9EA(), lineWidth: 1)
                            )
                    }
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
}

#Preview {
    EditProfileView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(UserSettings())
}

extension EditProfileView {
    private func getUserData() {
        viewModel.fetchUserData {
            name = viewModel.user?.full_name ?? ""
            phone = viewModel.user?.phone_number ?? ""
            email = viewModel.user?.email ?? ""
            hasCar = viewModel.user?.hasCar ?? false
            carType = viewModel.user?.carType ?? ""
            carModel = viewModel.user?.carModel ?? ""
            carColor = viewModel.user?.carColor ?? ""
            carNumber = viewModel.user?.carNumber ?? ""
        }
    }
    
    private func update() {
        var imageData: Data? = nil
        var imageCarFrontData: Data? = nil
        var imageCarBackData: Data? = nil
        var imageCarRightData: Data? = nil
        var imageCarLeftData: Data? = nil
        var imageIDData: Data? = nil
        var imageLicanseData: Data? = nil
        var additionalParams: [String: Any] = [:]

        if isImageSelected, let uiImage = mediaPickerViewModel.selectedImage {
            // Convert the UIImage to Data, if needed
            imageData = uiImage.jpegData(compressionQuality: 0.6)
        }
        
        if let uiImage = mediaPickerViewModel.selectedCarFrontImage {
            // Convert the UIImage to Data, if needed
            imageCarFrontData = uiImage.jpegData(compressionQuality: 0.5)
        }

        if let uiImage = mediaPickerViewModel.selectedCarBackImage {
            // Convert the UIImage to Data, if needed
            imageCarBackData = uiImage.jpegData(compressionQuality: 0.5)
        }

        if let uiImage = mediaPickerViewModel.selectedCarRightImage {
            // Convert the UIImage to Data, if needed
            imageCarRightData = uiImage.jpegData(compressionQuality: 0.5)
        }

        if let uiImage = mediaPickerViewModel.selectedCarLeftImage {
            // Convert the UIImage to Data, if needed
            imageCarLeftData = uiImage.jpegData(compressionQuality: 0.5)
        }

        if let uiImage = mediaPickerViewModel.selectedIDImage {
            // Convert the UIImage to Data, if needed
            imageIDData = uiImage.jpegData(compressionQuality: 0.5)
        }

        if let uiImage = mediaPickerViewModel.selectedLicanseImage {
            // Convert the UIImage to Data, if needed
            imageLicanseData = uiImage.jpegData(compressionQuality: 0.5)
        }

        additionalParams = [
            "email": email,
            "full_name": name,
            "lat": userLocation?.latitude ?? 0.0,
            "lng": userLocation?.longitude ?? 0.0,
            "hasCar": hasCar,
            "carType": carType,
            "carModel": carModel,
            "carColor": carColor,
            "carNumber": carNumber
        ]
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if let userLocation = userLocation {
            Utilities.getAddress(for: userLocation) { address in
                additionalParams["address"] = address
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            viewModel.updateUserDataWithImage(imageData: imageData, carFrontImageData: imageCarFrontData, carBackImageData: imageCarBackData, carRightImageData: imageCarRightData, carLeftImageData: imageCarLeftData, carIDImageData: imageIDData, carLicenseImageData: imageLicanseData, additionalParams: additionalParams) { hasCar, message in
                if !hasCar {
                    showMessage(message: LocalizedStringKey.successfullyUpdated)
                } else {
                    showMessage(message: message)
                }

            }
        }
    }
    
    private func showMessage(message: String) {
        let alertModel = AlertModel(
            title: LocalizedStringKey.message,
            message: message,
            hideCancelButton: true,
            onOKAction: {
                if hasCar {
                    router.navigateBack()
                    authViewModel.logoutUser {
                    }
                } else {
                    router.navigateBack()
                }
                router.dismiss()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
}

//
//  PersonalInfoView.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import SwiftUI
import PopupView
import MapKit

struct PersonalInfoView: View {
    @StateObject var mediaPickerViewModel = MediaPickerViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var hasCar = false
    @State private var carType = ""
    @State private var carModel = ""
    @State private var carColor = ""
    @State private var carNumber = ""
    @StateObject private var router: MainRouter
    private let errorHandling = ErrorHandling()
    @EnvironmentObject var settings: UserSettings
    @StateObject private var viewModel = UserViewModel(errorHandling: ErrorHandling())
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var uploadProgress: Double = 0.0
    private var isImageSelected: Bool {
        mediaPickerViewModel.selectedImage != nil
    }
    @State private var isFloatingPickerPresented = false
    @State private var isFloatingCarFrontImagePickerPresented = false
    @State private var isFloatingCarBackImagePickerPresented = false
    @State private var isFloatingCarRightImagePickerPresented = false
    @State private var isFloatingCarLeftImagePickerPresented = false
    @State private var isFloatingIdentityImagePickerPresented = false
    @State private var isFloatingLicenseImagePickerPresented = false

    init(router: MainRouter) {
        self._router = StateObject(wrappedValue: router)
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
                                // Placeholder image when no image is selected
                                Image(systemName: "photo.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                                    .font(Font.system(size: 20).weight(.light))
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
                            CustomTextField(text: $name, placeholder: LocalizedStringKey.fullName, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                .disabled(viewModel.isLoading)
                            CustomTextField(text: $email, placeholder: LocalizedStringKey.email, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
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
                                CustomTextField(text: $carType, placeholder: LocalizedStringKey.carType, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                CustomTextField(text: $carModel, placeholder: LocalizedStringKey.carModel, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                CustomTextField(text: $carColor, placeholder: LocalizedStringKey.carColor, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                CustomTextField(text: $carNumber, placeholder: LocalizedStringKey.carNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .disabled(viewModel.isLoading)
                                
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        createImageSection(image: mediaPickerViewModel.selectedCarFrontImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarFrontImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carFrontImage)

                                        Spacer()

                                        createImageSection(image: mediaPickerViewModel.selectedCarBackImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarBackImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carBackImage)
                                    }

                                    HStack(spacing: 16) {
                                        createImageSection(image: mediaPickerViewModel.selectedCarRightImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarRightImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carRightImage)

                                        Spacer()

                                        createImageSection(image: mediaPickerViewModel.selectedCarLeftImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingCarLeftImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.carLeftImage)
                                    }

                                    HStack(spacing: 16) {
                                        createImageSection(image: mediaPickerViewModel.selectedIDImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingIdentityImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.identityImage)

                                        Spacer()

                                        createImageSection(image: mediaPickerViewModel.selectedLicanseImage,
                                                           placeholder: "icloud.and.arrow.up",
                                                           action: { isFloatingLicenseImagePickerPresented.toggle() },
                                                           title: LocalizedStringKey.licenseImage)
                                    }
                                }
                            }
                        }

                        Spacer()

                        Button {
                            self.register()
                        } label: {
                            Text(LocalizedStringKey.completeRegisteration)
                        }
                        .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                        .disabled(viewModel.isLoading)

                        if let uploadProgress = viewModel.uploadProgress {
                            // Display the progress view only when upload is in progress
                            LinearProgressView(LocalizedStringKey.loading, progress: uploadProgress, color: .primary())
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .navigationTitle(LocalizedStringKey.personalInformation)
        .dismissKeyboard()
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
            // Use the user's current location if available
            if let userLocation = LocationManager.shared.userLocation {
                self.userLocation = userLocation
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage, .error))
            }
        }
    }
    
    private func createImageSection(image: UIImage?, placeholder: String, action: @escaping () -> Void, title: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(weight: .book, size: 16)
                .foregroundColor(.grayA4ACAD())

            Button(action: action) {
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120) // Adjust the size as needed
                        .background(Color.grayF9FAFA())
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                } else {
                    Image(systemName: placeholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120) // Adjust the size as needed
                        .foregroundColor(.gray)
                        .font(Font.system(size: 24).weight(.light)) // Adjust the font size
                        .padding(16)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
}

#Preview {
    PersonalInfoView(router: MainRouter(isPresented: .constant(.personalInfo)))
        .environmentObject(UserSettings())
}

extension PersonalInfoView {
    
    private func register() {
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
            imageData = uiImage.jpegData(compressionQuality: 0.5)
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
                    settings.loggedIn = true
                    router.replaceNavigationStack(path: [])
                } else {
                    showMessage(message: message)
                }
            }
        }
    }
    
    private func showMessage(message: String) {
        let alertModel = AlertModel(
            iconType: .logo,
            title: LocalizedStringKey.message,
            message: message,
            hideCancelButton: true,
            onOKAction: {
                router.replaceNavigationStack(path: [])
                router.dismiss()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
}

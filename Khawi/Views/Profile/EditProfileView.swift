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
    @State private var isFloatingPickerPresented = false
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    private let errorHandling = ErrorHandling()
    @StateObject private var viewModel = UserViewModel(errorHandling: ErrorHandling())
    @State private var userLocation: CLLocationCoordinate2D? = nil

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
        var additionalParams: [String: Any] = [:]

        if isImageSelected, let uiImage = mediaPickerViewModel.selectedImage {
            // Convert the UIImage to Data, if needed
            imageData = uiImage.jpegData(compressionQuality: 0.6)
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
        
        if let userLocation = userLocation {
            Utilities.getAddress(for: userLocation) { address in
                additionalParams["address"] = address
            }
        }

        viewModel.updateUserDataWithImage(imageData: imageData, additionalParams: additionalParams) {
            showMessage()
        }
    }
    
    private func showMessage() {
        let alertModel = AlertModel(
            title: LocalizedStringKey.message,
            message: LocalizedStringKey.successfullyUpdated,
            hideCancelButton: true,
            onOKAction: {
                router.dismiss()
                router.navigateBack()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
}

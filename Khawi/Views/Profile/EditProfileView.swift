//
//  EditProfileView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import PopupView

struct EditProfileView: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var mediaPickeriewModel = MediaPickerViewModel()
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var haveCar = false
    @State private var carType = ""
    @State private var carModel = ""
    @State private var carColor = ""
    @State private var carNumber = ""
    @State private var isFloatingPickerPresented = false
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter
    
    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        LoadingView(isShowing: $authViewModel.shouldAnimating) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ZStack {
                                if let img = mediaPickeriewModel.selectedImage {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else {
                                    AsyncImage(url: settings.myUser.image?.toURL()) { phase in
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
                            }
                            
                            VStack(spacing: 16) {
                                CustomTextFieldWithTitle(text: $name, placeholder: LocalizedStringKey.fullName, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                CustomTextFieldWithTitle(text: $phone, placeholder: LocalizedStringKey.phoneNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .keyboardType(.phonePad)
                                CustomTextFieldWithTitle(text: $email, placeholder: LocalizedStringKey.email, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    .keyboardType(.emailAddress)
                            }
                            .padding(.top, 12)
                            
                            Button {
                                withAnimation {
                                    haveCar.toggle()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: haveCar ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(haveCar ? .primary() : .grayDDDFDF())
                                    Text(LocalizedStringKey.areYouHaveCar)
                                        .customFont(weight: .book, size: 16)
                                        .foregroundColor(.black131313())
                                    Spacer()
                                }
                            }
                            
                            if haveCar {
                                VStack(spacing: 16) {
                                    CustomTextFieldWithTitle(text: $carType, placeholder: LocalizedStringKey.carType, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    CustomTextFieldWithTitle(text: $carModel, placeholder: LocalizedStringKey.carModel, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    CustomTextFieldWithTitle(text: $carColor, placeholder: LocalizedStringKey.carColor, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    CustomTextFieldWithTitle(text: $carNumber, placeholder: LocalizedStringKey.carNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                }
                            }

                            Spacer()

                            Button {
                                router.replaceNavigationStack(path: [])
                            } label: {
                                Text(LocalizedStringKey.saveChanges)
                            }
                            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                            
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: geometry.size.height)
                    }
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
        .fullScreenCover(isPresented: $mediaPickeriewModel.isPresentingImagePicker, content: {
            ImagePicker(sourceType: mediaPickeriewModel.sourceType, completionHandler: mediaPickeriewModel.didSelectImage)
        })
        .popup(isPresented: $isFloatingPickerPresented) {
            FloatingPickerView(
                isPresented: $isFloatingPickerPresented,
                onChoosePhoto: {
                    // Handle choosing a photo here
                    mediaPickeriewModel.choosePhoto()
                },
                onTakePhoto: {
                    // Handle taking a photo here
                    mediaPickeriewModel.takePhoto()
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
    }
}

#Preview {
    EditProfileView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(UserSettings())
}


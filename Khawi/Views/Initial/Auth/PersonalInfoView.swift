//
//  PersonalInfoView.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import SwiftUI
import PopupView

struct PersonalInfoView: View {
    @StateObject var authViewModel = AuthViewModel()
    @EnvironmentObject var settings: UserSettings
    @StateObject var mediaPickeriewModel = MediaPickerViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var haveCar = false
    @State private var carType = ""
    @State private var carModel = ""
    @State private var carColor = ""
    @State private var carNumber = ""
    @State private var isFloatingPickerPresented = false

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
                            }
                            
                            VStack(spacing: 16) {
                                CustomTextField(text: $name, placeholder: LocalizedStringKey.fullName, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                CustomTextField(text: $email, placeholder: LocalizedStringKey.email, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
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
                                    CustomTextField(text: $carType, placeholder: LocalizedStringKey.carType, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    CustomTextField(text: $carModel, placeholder: LocalizedStringKey.carModel, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    CustomTextField(text: $carColor, placeholder: LocalizedStringKey.carColor, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                    CustomTextField(text: $carNumber, placeholder: LocalizedStringKey.carNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                                }
                            }

                            Spacer()

                            Button {
                                register()
                            } label: {
                                Text(LocalizedStringKey.completeRegisteration)
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
        .navigationTitle(LocalizedStringKey.personalInformation)
        .dismissKeyboard()
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
        .popup(isPresented: $authViewModel.showErrorPopup) {
            ErrorToastView(title: $authViewModel.errorTitle, message: $authViewModel.errorMessage)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .autohideIn(2)
                .backgroundColor(.black.opacity(0.63))
        }
    }
}

#Preview {
    PersonalInfoView()
}

extension PersonalInfoView {
    private func register() {
        authViewModel.login(username: "", password: "", onsuccess: {
            print("sss")
            settings.id = 1
            settings.loggedIn = true
        })
    }
}

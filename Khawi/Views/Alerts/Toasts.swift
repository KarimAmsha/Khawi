//
//  Toasts.swift
//  GatherPoint
//
//  Created by Karim Amsha on 8.09.2023.
//

import SwiftUI

struct ToastTopFirst: View {
    var body: some View {
        Text("Unable to add to bag as this item is currently not available.")
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 60, leading: 32, bottom: 16, trailing: 32))
            .frame(maxWidth: .infinity)
            .background(Color(hex: "FE504E"))
    }
}

struct ToastTopSecond: View {
    var body: some View {
        HStack {
            Image("avatar3")
                .frame(width: 48, height: 48)
                .cornerRadius(24)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Camila Morrone")
                        .font(.system(size: 15))
                    
                    Spacer()
                    
                    Text("now")
                        .font(.system(size: 13))
                        .opacity(0.6)
                }
                
                Text("Let's go have a cup of coffee! ☕️")
                    .font(.system(size: 15, weight: .light))
            }
        }
        .foregroundColor(.white)
        .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color(hex: "87B9FF"))
    }
}

struct ToastBottomFirst: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image("fitness")
                .frame(width: 48, height: 48)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Log In to Fitness First")
                    .font(.system(size: 16, weight: .bold))
                Text("To continue training, you need to Log in or Sign up")
                    .font(.system(size: 16))
                    .opacity(0.8)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    self.isShowing = false
                } label: {
                    Text("Log in")
                        .frame(width: 112, height: 40)
                }
                .customButtonStyle(foreground: .white, background: Color(hex: "87B9FF"))
                .cornerRadius(8)

                Button {
                    self.isShowing = false
                } label: {
                    Text("Sign up")
                        .frame(width: 112, height: 40)
                }
                .customButtonStyle()
            }
        }
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 42, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

struct ToastBottomSecond: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image("checkmark")
                .frame(width: 48, height: 48)
                .cornerRadius(24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Subscription completed!")
                    .font(.system(size: 16, weight: .bold))
                Text("The next charge to your credit card will be made on May 25, 2022.")
                    .font(.system(size: 16, weight: .light))
                    .opacity(0.8)
            }
            
            Spacer()
        }
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 42, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: -4)
    }
}

struct ErrorToastView: View {
    @Binding var title: String
    @Binding var message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.red)
                .cornerRadius(24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .customFont(weight: .bold, size: 16)
                Text(message)
                    .customFont(weight: .book, size: 16)
                    .opacity(0.8)
            }
            
            Spacer()
        }
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 42, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: -4)
    }
}

struct GeneralErrorToastView: View {
    let title: String
    let message: String
    let iconType: IconType
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if iconType == . logo {
                Image("ic_logo")
                    .resizable()
                    .frame(width: 50, height: 70)
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding(16)
            } else {
                Image(systemName: iconType == .warning ? "exclamationmark.triangle" : iconType == .success ? "checkmark.circle" : "xmark.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundColor(iconType == .warning ? Color.primary() : iconType == .success ? Color.primary() : .red)
                    .cornerRadius(24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .customFont(weight: .bold, size: 16)
                Text(message)
                    .customFont(weight: .book, size: 16)
                    .opacity(0.8)
            }
            
            Spacer()
        }
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 42, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: -4)
    }
}

struct ToastGeneralSuccess: View {
    @EnvironmentObject var appState: AppState
    @Binding var toasts: ToastsState
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        VStack {
            // Create a line
            Rectangle()
                .frame(width: 50, height: 6)
                .overlay(
                    Rectangle()
                        .stroke(Color.white, lineWidth: 6)
                        .cornerRadius(3, corners: .allCorners)
                )

            VStack(spacing: 24) {
                Image("ic_c_success")
                    .resizable()
                    .frame(width: 95, height: 95)
                    .foregroundStyle(Color.black131313(), Color.primary())
                    .cornerRadius(25)
                
                Text("Congratulations!, Success")
                    .customFont(weight: .bold, size: 25)
                    .foregroundColor(.black131313())

                Button {
                    toasts.showingSuccess.toggle()
                } label: {
                    Text("Home Page")
                }
                .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                .padding(.top)
            }
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: -4)
            .padding(.top)
        }
    }
}


struct Toasts_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
            VStack {
                ToastTopFirst()
                ToastTopSecond()
                ToastBottomFirst(isShowing: Binding<Bool>.init(get: { true }, set: { _ in }))
                ToastBottomSecond()
                ToastGeneralSuccess(toasts: .constant(ToastsState()))
            }
        }
        .previewDevice("iPhone 13 Pro Max")
    }
}




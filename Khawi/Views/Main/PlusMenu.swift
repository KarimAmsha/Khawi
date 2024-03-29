//
//  PlusMenu.swift
//  Khawi
//
//  Created by Karim Amsha on 24.10.2023.
//

import SwiftUI

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    @StateObject var appState: AppState
    @Binding var showPopUp: Bool
    let onJoiningRequest: () -> Void
    let onDeliveryRequest: () -> Void

    var body: some View {
        HStack(spacing: 50) {
            VStack(spacing: 0) {
//                ZStack {
//                    Circle()
//                        .foregroundColor(.clear)
//                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image("ic_car_pin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
//                }
                Text(LocalizedStringKey.joiningRequest)
                    .customFont(weight: .book, size: 12)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                withAnimation {
                    appState.currentAddSelection = .joiningRequest
                    showPopUp.toggle()
                    onJoiningRequest()
                }
            }
            
            VStack(spacing: 0) {
//                ZStack {
//                    Circle()
//                        .foregroundColor(.clear)
//                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image("ic_person_pin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
//                }
                Text(LocalizedStringKey.deliveryRequest)
                    .customFont(weight: .book, size: 12)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                withAnimation {
                    appState.currentAddSelection = .deliveryRequest
                    showPopUp.toggle()
                    onDeliveryRequest()
                }
            }
        }
        .transition(.scale)
    }
}

#Preview {
    PlusMenu(widthAndHeight: 47, appState: AppState(), showPopUp: .constant(true)) {
        //
    } onDeliveryRequest: {
        //
    }
}

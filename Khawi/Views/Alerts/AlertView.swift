//
//  AlertView.swift
//  GatherPoint
//
//  Created by Karim Amsha on 27.08.2023.
//

import SwiftUI

struct AlertView: View {
    var alertModel: AlertModel

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Image("ic_logo")
                    .resizable()
                    .frame(width: 50, height: 70)
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding(16)
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(alertModel.title)
                            .customFont(weight: .bold, size: 15)
                        Text(alertModel.message)
                            .customFont(weight: .book, size: 14)
                    }
                    
                    HStack(spacing: 50) {
                        Button {
                            withAnimation {
                                alertModel.onOKAction()
                            }
                        } label: {
                            Text(LocalizedStringKey.ok)
                        }
                        .buttonStyle(PrimaryButton(fontSize: 15, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                        
                        if !alertModel.hideCancelButton {
                            Button {
                                alertModel.onCancelAction()
                            } label: {
                                Text(LocalizedStringKey.cancel)
                            }
                            .buttonStyle(PrimaryButton(fontSize: 15, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 44)
        .ignoresSafeArea()
        .background(.white)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
}

//
//  CancellationReasonView.swift
//  Khawi
//
//  Created by Karim Amsha on 13.11.2023.
//

import SwiftUI
import CTRating

struct InputAlertView: View {
    @State private var description: String = LocalizedStringKey.description
    @State var placeholderString = LocalizedStringKey.description
    var alertModel: AlertModelWithInput

    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey.cancellationReason)
                .customFont(weight: .bold, size: 14)

            TextEditor(text: self.$description)
                .foregroundColor(self.description == placeholderString ? .gray : .black)
                .customFont(weight: .book, size: 14)
                .frame(height: 100)
                .onTapGesture {
                    if self.description == placeholderString {
                        self.description = ""
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 14)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)
                )

            HStack(spacing: 50) {
                Button {
                    withAnimation {
                        alertModel.onOKAction(description)
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
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 44)
        .ignoresSafeArea()
        .background(.white)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
}

#Preview {
    InputAlertView(alertModel: AlertModelWithInput(title: "", content: "", hideCancelButton: true, onOKAction: {content in}, onCancelAction: {}))
}
//
//  FloatingPickerView.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI

struct FloatingPickerView: View {
    @Binding var isPresented: Bool
    var onChoosePhoto: () -> Void
    var onTakePhoto: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                onChoosePhoto()
                isPresented = false
            }) {
                Text("Choose Photo")
                    .customFont(weight: .book, size: 15)
                    .foregroundColor(.black131313())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Divider()
                .background(Color.grayECECEC())
                .frame(height: 1)
            Button(action: {
                onTakePhoto()
                isPresented = false
            }) {
                Text("Take Photo")
                    .customFont(weight: .book, size: 15)
                    .foregroundColor(.black131313())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Divider()
                .background(Color.grayECECEC())
                .frame(height: 1)
            Button(action: {
                isPresented = false
            }) {
                Text("Cancel")
                    .customFont(weight: .bold, size: 15)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10, corners: [.topLeft, .topRight])
    }
}

struct FloatingPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingPickerView(isPresented: .constant(false), onChoosePhoto: {}, onTakePhoto: {})
    }
}

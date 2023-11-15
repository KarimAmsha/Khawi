//
//  JoinRequestSuccessView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct JoinRequestSuccessView: View {
    @StateObject private var router: MainRouter
    var message: String = ""
    var orderID: String = ""

    init(orderID: String, message: String, router: MainRouter) {
        self.orderID = orderID
        self.message = message
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color.white, Color.green0CB057())
                .padding(23)
                .background(Color.green0CB057().opacity(0.2).clipShape(Circle()))
            
            Text(message)
                .customFont(weight: .book, size: 18)
                .foregroundColor(.grayA4ACAD())
            
            Button {
                router.dismiss()
                router.presentViewSpec(viewSpec: .joiningRequestOrderDetailsView(orderID))
            } label: {
                Text(LocalizedStringKey.showRequestDetails)
            }
            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
            .padding(.top, 10)
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
    JoinRequestSuccessView(orderID: "", message: "", router: MainRouter(isPresented: .constant(.main)))
}

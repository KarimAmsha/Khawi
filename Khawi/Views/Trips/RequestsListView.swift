//
//  RequestsListView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct RequestsListView: View {
    let items: [Int] = Array(1...3)
    @StateObject var settings: UserSettings
    @StateObject private var router: MainRouter

    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        ScrollView {
            ForEach(items, id: \.self) { item in
                RequestsRowView(settings: settings, router: router)
            }
        }
    }
}

#Preview {
    RequestsListView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}


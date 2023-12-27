//
//  TabBarIcon.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI

struct TabBarIcon: View {
    
    @StateObject var appState: AppState
    let assignedPage: Page
    @ObservedObject private var settings = UserSettings()

    let width, height: CGFloat
    let iconName, tabName: String
    let isAddButton: Bool

    var body: some View {
        VStack {
            if isAddButton {
                HStack{
                    Spacer()
                    
                    ZStack {
                        Text("+")
                            .customFont(weight: .bold, size: 13)
                            .foregroundColor(appState.currentPage == assignedPage ? Color.primary() : Color.gray595959())
                    }
                    .frame(width: 20, height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(appState.currentPage == assignedPage ? Color.primary() : Color.gray595959(), lineWidth: 2)
                    )
                    .padding(10)

                    Spacer()
                }
            } else {
                HStack{
                    Spacer()
                    VStack(spacing: 2) {
                        ZStack {
                            if assignedPage == .notifications {
                                Text("\(appState.notificationCountString ?? "")")
                                    .customFont(weight: .book, size: 12)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 10, y: -10)
                                    .opacity(appState.notificationCountString == nil || appState.notificationCountString?.toInt() == 0 ? 0 : 1)
                            }
                            Image(iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(appState.currentPage == assignedPage ? Color.primary() : Color.black666666())
                        }
                        Text(tabName)
                            .customFont(weight: .book, size: 12)
                            .foregroundColor(appState.currentPage == assignedPage ? Color.primary() : Color.black666666())
                    }
                    .padding(10)
                    Spacer()
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding(.horizontal, -10)
        .padding(.top, -5)
        .onTapGesture {
            appState.currentPage = assignedPage
        }
    }
}

#Preview {
    TabBarIcon(appState: AppState(), assignedPage: .home, width: 38, height: 38, iconName: "ic_home", tabName: LocalizedStringKey.home, isAddButton: false)
}


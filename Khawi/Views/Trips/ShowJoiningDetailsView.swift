//
//  ShowJoiningDetailsView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import CTRating

struct ShowJoiningDetailsView: View {
    @StateObject var settings: UserSettings

    let weekDays: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ar")
        return calendar.shortWeekdaySymbols
    }()
    @StateObject private var router: MainRouter
    @State private var selectedDays: [String] = ["أحد", "اثنين", "ثلاثاء"]

    init(settings: UserSettings, router: MainRouter) {
        _settings = StateObject(wrappedValue: settings)
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            AsyncImage(url: settings.myUser.image?.toURL()) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // Placeholder while loading
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle()) // Clip the image to a circle
                                case .failure:
                                    Image(systemName: "photo.circle") // Placeholder for failure
                                        .imageScale(.large)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2))
                            )
                            
                            Text("أحمد علي")
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.black141F1F())
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Text(":\(LocalizedStringKey.from)")
                                    .foregroundColor(.black141F1F())
                                Text("الرياض")
                                    .foregroundColor(.blue288599())
                            }
                            HStack(spacing: 4) {
                                Text(":\(LocalizedStringKey.to)")
                                    .foregroundColor(.black141F1F())
                                Text("جدة")
                                    .foregroundColor(.blue288599())
                            }
                        }
                        .customFont(weight: .book, size: 14)
                    }
                    
                    Button {
                        router.presentViewSpec(viewSpec: .showOnMap)
                    } label: {
                        Text(LocalizedStringKey.showOnMap)
                            .customFont(weight: .book, size: 12)
                    }
                    .buttonStyle(CustomButtonStyle())
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.tripDate)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text("07:30 صباحاً")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.black141F1F())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )

                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey.dateOfTheFirstTrip)
                                .customFont(weight: .book, size: 11)
                                .foregroundColor(.grayA4ACAD())
                            Text("15 ربيع الأول، 1445")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.black141F1F())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey.tripDays)
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.gray4E5556())
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(weekDays, id: \.self) { day in
                                    VStack(spacing: 15) {
                                        Text(day)
                                            .customFont(weight: .book, size: 12)
                                            .foregroundColor(.grayA4ACAD())

                                        if selectedDays.contains(day) {
                                            Circle()
                                                .fill(Color.primary())
                                                .frame(width: 32, height: 32)
                                        } else {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .foregroundStyle(Color.grayF9FAFA(), Color.grayE6E9EA())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey.price)
                            .customFont(weight: .book, size: 11)
                            .foregroundColor(.grayA4ACAD())
                        Text("\(LocalizedStringKey.sar) 25")
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.black141F1F())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color.grayF9FAFA())
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.grayE6E9EA(), lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStringKey.notes)
                            .customFont(weight: .book, size: 14)
                            .foregroundColor(.gray4E5556())
                        
                        VStack(alignment: .leading) {
                            Text("انا  أحب الالتزام بالمواعيد و الهدوء أثناء الرحلة\n اتمنى ان يكون السعر مناسب، شكراً لك.")
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(.black141F1F())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button {
                        } label: {
                            Text(LocalizedStringKey.requestAccept)
                        }
                        .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .green46CF85(), foreground: .white, height: 48, radius: 12))

                        Button {
                        } label: {
                            Text(LocalizedStringKey.requestReject)
                        }
                        .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .redFF5B5B(), foreground: .white, height: 48, radius: 12))
                    }
                }
                .frame(minWidth: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .padding(24)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.joiningRequest)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
    }
}

#Preview {
    ShowJoiningDetailsView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
}

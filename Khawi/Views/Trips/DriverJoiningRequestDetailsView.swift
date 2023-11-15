//
//  DriverJoiningRequestDetailsView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

//import SwiftUI
//import CTRating
//
//struct DriverJoiningRequestDetailsView: View {
//    @StateObject var settings: UserSettings
//
//    let weekDays: [String] = {
//        var calendar = Calendar.current
//        calendar.locale = Locale(identifier: "ar")
//        return calendar.shortWeekdaySymbols
//    }()
//    @StateObject private var router: MainRouter
//    @State private var selectedDays: [String] = ["أحد", "اثنين", "ثلاثاء"]
//
//    init(settings: UserSettings, router: MainRouter) {
//        _settings = StateObject(wrappedValue: settings)
//        _router = StateObject(wrappedValue: router)
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 20) {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text("14 ربيع الأول، 1445 هـ")
//                                .customFont(weight: .book, size: 12)
//                                .foregroundColor(.gray898989())
//                            Spacer()
//                            Text(OrderStatus.new.value)
//                                .customFont(weight: .bold, size: 10)
//                                .foregroundColor(.blue0094FF())
//                                .padding(.horizontal, 30)
//                                .padding(.vertical, 7)
//                                .background(Color.blue0094FF().opacity(0.06).cornerRadius(12))
//                        }
//                        Text("عنوان الرحلة: دوام أسبوعي")
//                            .customFont(weight: .bold, size: 16)
//                            .foregroundColor(.black141F1F())
//                        HStack(spacing: 12) {
//                            HStack(spacing: 4) {
//                                Text(":\(LocalizedStringKey.from)")
//                                    .foregroundColor(.black141F1F())
//                                Text("الرياض")
//                                    .foregroundColor(.blue288599())
//                            }
//                            HStack(spacing: 4) {
//                                Text(":\(LocalizedStringKey.to)")
//                                    .foregroundColor(.black141F1F())
//                                Text("جدة")
//                                    .foregroundColor(.blue288599())
//                            }
//                        }
//                        .customFont(weight: .book, size: 14)
//                        
//                        Button {
////                            router.presentViewSpec(viewSpec: .showOnMap)
//                        } label: {
//                            Text(LocalizedStringKey.showOnMap)
//                                .customFont(weight: .book, size: 12)
//                        }
//                        .buttonStyle(CustomButtonStyle())
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text(LocalizedStringKey.joiningRequests)
//                            .customFont(weight: .book, size: 14)
//                            .foregroundColor(.gray4E5556())
//                        RequestsListView(settings: settings, router: router)
//                    }
//                    
//                    HStack(spacing: 16) {
//                        VStack(alignment: .leading) {
//                            Text(LocalizedStringKey.tripDate)
//                                .customFont(weight: .book, size: 11)
//                                .foregroundColor(.grayA4ACAD())
//                            Text("07:30 صباحاً")
//                                .customFont(weight: .book, size: 14)
//                                .foregroundColor(.black141F1F())
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(12)
//                        .background(Color.grayF9FAFA())
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                        )
//
//                        VStack(alignment: .leading) {
//                            Text(LocalizedStringKey.dateOfTheFirstTrip)
//                                .customFont(weight: .book, size: 11)
//                                .foregroundColor(.grayA4ACAD())
//                            Text("15 ربيع الأول، 1445")
//                                .customFont(weight: .book, size: 14)
//                                .foregroundColor(.black141F1F())
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(12)
//                        .background(Color.grayF9FAFA())
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                        )
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text(LocalizedStringKey.tripDays)
//                            .customFont(weight: .book, size: 14)
//                            .foregroundColor(.gray4E5556())
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(weekDays, id: \.self) { day in
//                                    VStack(spacing: 15) {
//                                        Text(day)
//                                            .customFont(weight: .book, size: 12)
//                                            .foregroundColor(.grayA4ACAD())
//
//                                        if selectedDays.contains(day) {
//                                            Circle()
//                                                .fill(Color.primary())
//                                                .frame(width: 32, height: 32)
//                                        } else {
//                                            Image(systemName: "circle")
//                                                .resizable()
//                                                .frame(width: 32, height: 32)
//                                                .foregroundStyle(Color.grayF9FAFA(), Color.grayE6E9EA())
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                                        
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text(LocalizedStringKey.driverInformations)
//                            .customFont(weight: .book, size: 14)
//                            .foregroundColor(.gray4E5556())
//                        
//                        HStack {
//                            AsyncImage(url: settings.user?.image?.toURL()) { phase in
//                                switch phase {
//                                case .empty:
//                                    ProgressView() // Placeholder while loading
//                                case .success(let image):
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 40, height: 40)
//                                        .clipShape(Circle()) // Clip the image to a circle
//                                case .failure:
//                                    Image(systemName: "photo.circle") // Placeholder for failure
//                                        .imageScale(.large)
//                                        .foregroundColor(.gray)
//                                @unknown default:
//                                    EmptyView()
//                                }
//                            }
//                            .frame(width: 40, height: 40)
//                            .clipShape(Circle())
//                            .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2))
//                            )
//                            
//                            VStack(spacing: 6) {
//                                Text("أحمد علي")
//                                    .customFont(weight: .book, size: 16)
//                                    .foregroundColor(.black141F1F())
//                                CTRating(maxRating: 5,
//                                         currentRating: Binding.constant(3),
//                                         width: 14,
//                                         color: UIColor(Color.primary()),
//                                         openSFSymbol: "star",
//                                         fillSFSymbol: "star.fill")
//                            }
//                            
//                            Spacer()
//                            
//                            Button {
//                                router.replaceNavigationStack(path: [])
//                                router.presentToastPopup(view: .review)
//                            } label: {
//                                Text(LocalizedStringKey.addReview)
//                                    .customFont(weight: .book, size: 12)
//                                    .padding(.horizontal)
//                            }
//                            .buttonStyle(CustomButtonStyle())
//                        }
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text(LocalizedStringKey.carInformation)
//                            .customFont(weight: .book, size: 14)
//                            .foregroundColor(.gray4E5556())
//                        
//                        VStack(spacing: 12) {
//                            HStack(spacing: 16) {
//                                VStack(alignment: .leading) {
//                                    Text(LocalizedStringKey.carType)
//                                        .customFont(weight: .book, size: 11)
//                                        .foregroundColor(.grayA4ACAD())
//                                    Text("BMW")
//                                        .customFont(weight: .book, size: 14)
//                                        .foregroundColor(.black141F1F())
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(12)
//                                .background(Color.grayF9FAFA())
//                                .cornerRadius(12)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                                )
//
//                                VStack(alignment: .leading) {
//                                    Text(LocalizedStringKey.carModel)
//                                        .customFont(weight: .book, size: 11)
//                                        .foregroundColor(.grayA4ACAD())
//                                    Text("X6")
//                                        .customFont(weight: .book, size: 14)
//                                        .foregroundColor(.black141F1F())
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(12)
//                                .background(Color.grayF9FAFA())
//                                .cornerRadius(12)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                                )
//                            }
//
//                            HStack(spacing: 16) {
//                                VStack(alignment: .leading) {
//                                    Text(LocalizedStringKey.carColor)
//                                        .customFont(weight: .book, size: 11)
//                                        .foregroundColor(.grayA4ACAD())
//                                    Text("سوداء")
//                                        .customFont(weight: .book, size: 14)
//                                        .foregroundColor(.black141F1F())
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(12)
//                                .background(Color.grayF9FAFA())
//                                .cornerRadius(12)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                                )
//
//                                VStack(alignment: .leading) {
//                                    Text(LocalizedStringKey.carNumber)
//                                        .customFont(weight: .book, size: 11)
//                                        .foregroundColor(.grayA4ACAD())
//                                    Text("152454852")
//                                        .customFont(weight: .book, size: 14)
//                                        .foregroundColor(.black141F1F())
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(12)
//                                .background(Color.grayF9FAFA())
//                                .cornerRadius(12)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                                )
//                            }
//                            
//                            VStack(alignment: .leading) {
//                                Text(LocalizedStringKey.numberOfAvailableSeats)
//                                    .customFont(weight: .book, size: 11)
//                                    .foregroundColor(.grayA4ACAD())
//                                Text("3 مقاعد")
//                                    .customFont(weight: .book, size: 14)
//                                    .foregroundColor(.black141F1F())
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(12)
//                            .background(Color.grayF9FAFA())
//                            .cornerRadius(12)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                            )
//                        }
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text(LocalizedStringKey.driverNotes)
//                            .customFont(weight: .book, size: 14)
//                            .foregroundColor(.gray4E5556())
//                        
//                        VStack(alignment: .leading) {
//                            Text("السيارة مكيفة و مريحة ستنال اعجابكم.\n انا مهتم جداً بالنظافة والالتزام في المواعيد.")
//                                .customFont(weight: .book, size: 14)
//                                .foregroundColor(.black141F1F())
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(12)
//                        .background(Color.grayF9FAFA())
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                        )
//                    }
//                }
//                .frame(minWidth: geometry.size.width)
//            }
//        }
//        .padding(24)
//        .navigationTitle("")
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                VStack {
//                    Text(LocalizedStringKey.orderDetails)
//                        .customFont(weight: .book, size: 20)
//                      .foregroundColor(Color.black141F1F())
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    DriverJoiningRequestDetailsView(settings: UserSettings(), router: MainRouter(isPresented: .constant(.main)))
//}

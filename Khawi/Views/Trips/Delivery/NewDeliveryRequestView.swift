//
//  NewDeliveryRequestView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI
import MapKit

struct NewDeliveryRequestView: View {
    @StateObject private var router: MainRouter
    @State private var title = ""
    @State private var price = ""
    @State private var isDailyTrip = false
    @State private var passengersCount = ""
    @State private var note = ""
    @EnvironmentObject var appState: AppState
    @State private var popoverSize = CGSize(width: 320, height: 300)
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var dateStr: String = ""
    @State private var timeStr: String = ""
    let weekDays: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ar")
        return calendar.shortWeekdaySymbols
    }()
    @State private var selectedDays = [String]()
    @State private var isAgree = false
    @StateObject private var ordersViewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())
    private let errorHandling = ErrorHandling()

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    CustomTextField(text: $title, placeholder: LocalizedStringKey.tripTitleOptional, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        .disabled(ordersViewModel.isLoading)

                    Button {
                        router.presentViewSpec(viewSpec: .selectDestination)
                    } label: {
                        HStack {
                            Text(destinationLabel())
                                .customFont(weight: .book, size: 14)
                                .foregroundColor(destinationSelected() ? .green0CB057() : .black666666())
                            Spacer()
                            if destinationSelected() {
                                Image("ic_edit")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black666666())

                            } else {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.black666666())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color.grayF9FAFA())
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.grayE6E9EA(), lineWidth: 1)
                    )
                    .disabled(ordersViewModel.isLoading)

                    CustomTextField(text: $price, placeholder: LocalizedStringKey.specifyPrice, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        .keyboardType(.numberPad)
                        .disabled(ordersViewModel.isLoading)

                    Button {
                        withAnimation {
                            isDailyTrip.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: isDailyTrip ? "checkmark.square.fill" : "square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isDailyTrip ? .primary() : .grayDDDFDF())
                            Text(LocalizedStringKey.isDailyTrip)
                                .customFont(weight: .book, size: 16)
                                .foregroundColor(.gray4E5556())
                            Spacer()
                        }
                    }
                    .disabled(ordersViewModel.isLoading)

                    if isDailyTrip {
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
                                                .onTapGesture {
                                                    toggleDaySelection(day)
                                                }
                                                .disabled(ordersViewModel.isLoading)
                                        } else {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .foregroundStyle(Color.grayF9FAFA(), Color.grayE6E9EA())
                                                .onTapGesture {
                                                    toggleDaySelection(day)
                                                }
                                                .disabled(ordersViewModel.isLoading)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
//                    WithPopover(showPopover: $appState.showingDatePicker, popoverSize: popoverSize) {
//                        Button(action: {
//                            withAnimation {
//                                appState.showingDatePicker.toggle()
//                            }
//                        }) {
//                            HStack {
//                                Text(dateStr.isEmpty ? LocalizedStringKey.tripDate : dateStr)
//                                    .customFont(weight: .book, size: 14)
//                                Spacer()
//                                Spacer()
//                                Image(systemName: "arrow.left")
//                                    .resizable()
//                                    .frame(width: 10, height: 10)
//                            }
//                            .foregroundColor(.black666666())
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(12)
//                        .background(Color.grayF9FAFA())
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                        )
//                        .disabled(ordersViewModel.isLoading)
//                    } popoverContent: {
//                        VStack {
//                            HStack(alignment: .firstTextBaseline, spacing: 0) {
//                                Button(LocalizedStringKey.cancel) {
//                                    withAnimation {
//                                        appState.showingDatePicker.toggle()
//                                    }
//                                }
//                                .buttonStyle(PopOverButtonStyle())
//                                Spacer()
//                                Button(LocalizedStringKey.done) {
//                                    appState.showingDatePicker.toggle()
//                                    dateStr = date.toString(format: "yyyy-MM-dd")
//                                }
//                                .buttonStyle(PopOverButtonStyle())
//                            }
//                            .padding([.leading, .trailing], 20)
//                            
//                            DatePicker(LocalizedStringKey.tripDate, selection: $date,
//                                       in: Date()...,
//                                       displayedComponents: .date)
//                                .labelsHidden()
//                                .datePickerStyle(WheelDatePickerStyle())
//                                .padding(.bottom, -40)
//                                .transition(.opacity)
//                                .onDisappear {
//                                    dateStr = date.toString(format: "yyyy-MM-dd")
//                                }
//                        }
//                    }
                    
//                    WithPopover(showPopover: $appState.showingTimePicker, popoverSize: popoverSize) {
//                        Button(action: {
//                            withAnimation {
//                                appState.showingTimePicker.toggle()
//                            }
//                        }) {
//                            HStack {
//                                Text(timeStr.isEmpty ? LocalizedStringKey.tripTime : timeStr)
//                                    .customFont(weight: .book, size: 14)
//                                Spacer()
//                                Spacer()
//                                Image(systemName: "arrow.left")
//                                    .resizable()
//                                    .frame(width: 10, height: 10)
//                            }
//                            .foregroundColor(.black666666())
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(12)
//                        .background(Color.grayF9FAFA())
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
//                        )
//                        .disabled(ordersViewModel.isLoading)
//                    } popoverContent: {
//                        VStack {
//                            HStack(alignment: .firstTextBaseline, spacing: 0) {
//                                Button(LocalizedStringKey.cancel) {
//                                    withAnimation {
//                                        appState.showingTimePicker.toggle()
//                                    }
//                                }
//                                .buttonStyle(PopOverButtonStyle())
//                                Spacer()
//                                Button(LocalizedStringKey.done) {
//                                    appState.showingTimePicker.toggle()
//                                    timeStr = time.toString(format: "hh: mm a")
//                                }
//                                .buttonStyle(PopOverButtonStyle())
//                            }
//                            .padding([.leading, .trailing], 20)
//                            
//                            DatePicker(LocalizedStringKey.tripTime, selection: $time,
//                                       displayedComponents: .hourAndMinute)
//                                .labelsHidden()
//                                .datePickerStyle(WheelDatePickerStyle())
//                                .padding(.bottom, -40)
//                                .transition(.opacity)
//                                .onDisappear {
//                                    timeStr = time.toString(format: "hh: mm a")
//                                }
//                        }
//                    }
                    
                    CustomTextField(text: $passengersCount, placeholder: LocalizedStringKey.passengersCount, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        .keyboardType(.numberPad)
                        .disabled(ordersViewModel.isLoading)

                    CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        .disabled(ordersViewModel.isLoading)

                    Button {
                        withAnimation {
                            isAgree.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: isAgree ? "checkmark.square.fill" : "square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isAgree ? .primary() : .grayDDDFDF())
                            HStack(spacing: 4) {
                                Text(LocalizedStringKey.agreeOn)
                                    .customFont(weight: .book, size: 14)
                                    .foregroundColor(.gray4E5556())
                                Text(LocalizedStringKey.termsConditions)
                                    .customFont(weight: .book, size: 14)
                                    .foregroundColor(.blue006E85())
                            }
                            Spacer()
                        }
                    }
                    .disabled(ordersViewModel.isLoading)

                    // Show a loader while creating
                    if ordersViewModel.isLoading {
                        LoadingView()
                    }

                    Spacer()

                    Button {
                        if !isAgree {
                            showAlertView()
                            return
                        }
                        add()
                    } label: {
                        Text(LocalizedStringKey.submitDeliveryRequest)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                    .disabled(ordersViewModel.isLoading)
                    .padding(.top, 10)
                }
                .frame(minWidth: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .padding(24)
        .navigationTitle("")
        .dismissKeyboard()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.deliveryRequest)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onChange(of: ordersViewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage, .error))
            }
        }
    }
    
    func destinationLabel() -> String {
        if appState.startPoint != nil, appState.endPoint != nil {
            return LocalizedStringKey.destinationSelected
        } else {
            return LocalizedStringKey.specifyDestinationOnMap
        }
    }

    func destinationSelected() -> Bool {
        if title.isEmpty, let endPoint = appState.endPoint {
            Utilities.getShortAddress(for: endPoint.coordinate) { address in
                title = address
            }
        }
        
        return appState.startPoint != nil && appState.endPoint != nil
    }

    func toggleDaySelection(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

#Preview {
    NewDeliveryRequestView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}

extension NewDeliveryRequestView {
    private func showAlertView() {
        let alertModel = AlertModel(
            iconType: .logo,
            title: LocalizedStringKey.message,
            message: LocalizedStringKey.agreeOnTerms, 
            hideCancelButton: false,
            onOKAction: {
                isAgree = true
                router.dismiss()
            },
            onCancelAction: {
                router.dismiss()
            }
        )
        
        router.presentToastPopup(view: .alert(alertModel))
    }
    
    func add() {
        let params: [String: Any] = [
            "couponCode": "",
            "paymentType": 1,
            "dt_date": dateStr,
            "dt_time": timeStr,
            "title": title,
            "max_price": price.toInt() ?? 0,
            "min_price": price.toInt() ?? 0,
            "price": price.toInt() ?? 0,
            "is_repeated": isDailyTrip,
            "days": selectedDays,
            "orderType": 2,
            "max_passenger": passengersCount.toInt() ?? 0,
            "notes": note
        ]
        
        if let startPoint = appState.startPoint, let endPoint = appState.endPoint {
            addOrderWithAddresses(startPoint: startPoint, endPoint: endPoint, params: params) { orderID, message in
                router.replaceNavigationStack(path: [])
                router.presentToastPopup(view: .createDeliverySuccess(orderID, message))
            }
        } else {
            ordersViewModel.addOrder(params: params) { orderID, message  in
                appState.clearMarks()
                router.replaceNavigationStack(path: [])
                router.presentToastPopup(view: .createDeliverySuccess(orderID, message))
            }
        }
    }

    func addOrderWithAddresses(startPoint: Mark, endPoint: Mark, params: [String: Any], completion: @escaping (String, String) -> Void) {
        var paramsWithAddresses = params
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Utilities.getAddress(for: startPoint.coordinate) { address in
            paramsWithAddresses["f_lat"] = startPoint.coordinate.latitude
            paramsWithAddresses["f_lng"] = startPoint.coordinate.longitude
            paramsWithAddresses["f_address"] = address
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Utilities.getAddress(for: endPoint.coordinate) { address in
            paramsWithAddresses["t_lat"] = endPoint.coordinate.latitude
            paramsWithAddresses["t_lng"] = endPoint.coordinate.longitude
            paramsWithAddresses["t_address"] = address
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            // All address requests have completed
            ordersViewModel.addOrder(params: paramsWithAddresses) { orderID, message in
                appState.clearMarks()
                completion(orderID, message)
            }
        }
    }
}

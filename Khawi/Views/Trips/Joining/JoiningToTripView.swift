//
//  JoiningToTripView.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import MapKit

struct JoiningToTripView: View {
    @StateObject private var router: MainRouter
    @State private var location = ""
    @State private var price = ""
    @State private var isDailyTrip = false
    @State private var note = ""
    @EnvironmentObject var appState: AppState
    @State private var popoverSize = CGSize(width: 320, height: 300)
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var dateStr: String = ""
    @State private var timeStr: String = ""
    @StateObject private var ordersViewModel = OrdersViewModel(initialRegion: MKCoordinateRegion(), errorHandling: ErrorHandling())
    var order: Order?

    init(order: Order?, router: MainRouter) {
        self.order = order
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
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

                    VStack(alignment: .leading, spacing: 6) {
                        CustomTextField(text: $price, placeholder: LocalizedStringKey.specifyPrice, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                            .keyboardType(.numberPad)
                            .disabled(ordersViewModel.isLoading)
                        Text(" \(order?.min_price?.toString() ?? "") - \(order?.max_price?.toString() ?? "") \(LocalizedStringKey.rangeOfPrice)")
                            .customFont(weight: .book, size: 12)
                            .foregroundColor(.primary())
                    }
                    
                    WithPopover(showPopover: $appState.showingDatePicker, popoverSize: popoverSize) {
                        Button(action: {
                            appState.showingDatePicker.toggle()
                        }) {
                            HStack {
                                Text(dateStr.isEmpty ? LocalizedStringKey.tripDate : dateStr)
                                    .customFont(weight: .book, size: 14)
                                Spacer()
                                Spacer()
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                            .foregroundColor(.black666666())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                    } popoverContent: {
                        VStack {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Button(LocalizedStringKey.cancel) {
                                    withAnimation {
                                        appState.showingDatePicker.toggle()
                                    }
                                }
                                .buttonStyle(PopOverButtonStyle())
                                Spacer()
                                Button(LocalizedStringKey.done) {
                                    appState.showingDatePicker.toggle()
                                    dateStr = date.toString(format: "yyyy-MM-dd")
                                }
                                .buttonStyle(PopOverButtonStyle())
                            }
                            .padding([.leading, .trailing], 20)
                            
                            DatePicker(LocalizedStringKey.tripDate, selection: $date,
                                       in: ...Date(),
                                       displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .padding(.bottom, -40)
                                .transition(.opacity)
                                .onDisappear {
                                    dateStr = date.toString(format: "yyyy-MM-dd")
                                }
                        }
                    }
                    
                    WithPopover(showPopover: $appState.showingTimePicker, popoverSize: popoverSize) {
                        Button(action: {
                            appState.showingTimePicker.toggle()
                        }) {
                            HStack {
                                Text(timeStr.isEmpty ? LocalizedStringKey.tripTime : timeStr)
                                    .customFont(weight: .book, size: 14)
                                Spacer()
                                Spacer()
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                            .foregroundColor(.black666666())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.grayF9FAFA())
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayE6E9EA(), lineWidth: 1)
                        )
                    } popoverContent: {
                        VStack {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Button(LocalizedStringKey.cancel) {
                                    withAnimation {
                                        appState.showingTimePicker.toggle()
                                    }
                                }
                                .buttonStyle(PopOverButtonStyle())
                                Spacer()
                                Button(LocalizedStringKey.done) {
                                    appState.showingTimePicker.toggle()
                                    timeStr = time.toString(format: "hh: mm a")
                                }
                                .buttonStyle(PopOverButtonStyle())
                            }
                            .padding([.leading, .trailing], 20)
                            
                            DatePicker(LocalizedStringKey.tripTime, selection: $time,
                                       displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .padding(.bottom, -40)
                                .transition(.opacity)
                                .onDisappear {
                                    timeStr = time.toString(format: "hh: mm a")
                                }
                        }
                    }

                    CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())

                    Spacer()

                    // Show a loader while creating
                    if ordersViewModel.isLoading {
                        LoadingView()
                    }

                    Button {
                        join()
                    } label: {
                        Text(LocalizedStringKey.joinToTrip)
                    }
                    .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
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
                    Text(LocalizedStringKey.joinToTrip)
                        .customFont(weight: .book, size: 20)
                      .foregroundColor(Color.black141F1F())
                }
            }
        }
        .onChange(of: ordersViewModel.errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                router.presentToastPopup(view: .error("", errorMessage))
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
        return appState.startPoint != nil && appState.endPoint != nil
    }
}

#Preview {
    JoiningToTripView(order: nil, router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}

extension JoiningToTripView {
    func join() {
        guard let order = order else {
            // Handle the case where order is nil
            return
        }

        var params: [String: Any] = [
            "dt_date": dateStr,
            "dt_time": timeStr,
        ]

        // Check and unwrap price and note before adding them to params
        if let priceValue = price.toInt() {
            params["price"] = priceValue
        }

        if let noteValue = note.toInt() {
            params["notes"] = noteValue
        }
        
        if let startPoint = appState.startPoint, let endPoint = appState.endPoint {
            joinWithAddresses(order: order, startPoint: startPoint, endPoint: endPoint, params: params) {message in
                appState.clearMarks()
                router.replaceNavigationStack(path: [])
                router.presentToastPopup(view: .joiningSuccess(order.id ?? "", message))
            }
        } else {
            ordersViewModel.addOfferToOrder(orderId: order.id ?? "", params: params) { message in
                appState.clearMarks()
                router.replaceNavigationStack(path: [])
                router.presentToastPopup(view: .joiningSuccess(order.id ?? "", message))
            }
        }
    }
    
    func joinWithAddresses(order: Order, startPoint: Mark, endPoint: Mark, params: [String: Any], completion: @escaping (String) -> Void) {
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
            ordersViewModel.addOfferToOrder(orderId: order.id ?? "", params: paramsWithAddresses) { message in
                completion(message)
            }
        }
    }
}

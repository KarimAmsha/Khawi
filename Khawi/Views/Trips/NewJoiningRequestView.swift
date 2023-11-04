//
//  NewJoiningRequestView.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import SwiftUI

struct NewJoiningRequestView: View {
    @StateObject private var router: MainRouter
    @State private var title = ""
    @State private var minPrice = ""
    @State private var maxPrice = ""
    @State private var isDailyTrip = false
    @State private var note = ""
    @EnvironmentObject var appState: AppState
    @State private var popoverSize = CGSize(width: 320, height: 300)
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var dateStr: String = ""
    @State private var timeStr: String = ""
    @State private var maxPassengers = ""
    let weekDays: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ar")
        return calendar.shortWeekdaySymbols
    }()
    @State private var selectedDays = [String]()

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    CustomTextField(text: $title, placeholder: LocalizedStringKey.tripTitle, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())

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

                    HStack(spacing: 12) {
                        CustomTextField(text: $minPrice, placeholder: LocalizedStringKey.minPrice, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                        CustomTextField(text: $maxPrice, placeholder: LocalizedStringKey.maxPrice, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())
                    }
                    
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
                                        } else {
                                            Image(systemName: "circle")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .foregroundStyle(Color.grayF9FAFA(), Color.grayE6E9EA())
                                                .onTapGesture {
                                                    toggleDaySelection(day)
                                                }
                                        }
                                    }
                                }
                            }
                        }
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
                                    appState.showingDatePicker.toggle()
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
                                .animation(.linear)
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
                                    appState.showingTimePicker.toggle()
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
                                .animation(.linear)
                                .transition(.opacity)
                                .onDisappear {
                                    timeStr = time.toString(format: "hh: mm a")
                                }
                        }
                    }
                    
                    CustomTextField(text: $maxPassengers, placeholder: LocalizedStringKey.maxPassengersNumber, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())

                    CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())

                    Spacer()

                    Button {
                        if destinationSelected() {
                            router.replaceNavigationStack(path: [])
                            router.presentToastPopup(view: .createJoiningSuccess)
                        } else {
                            appState.toastTitle = LocalizedStringKey.error
                            appState.toastMessage = LocalizedStringKey.pleaseSpecifyStartPoint + "\n" + LocalizedStringKey.pleaseSpecifyEndPoint
                            router.presentToastPopup(view: .error)
                        }
                    } label: {
                        Text(LocalizedStringKey.submitJoinRequest)
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
    
    func destinationLabel() -> String {
        if let startPoint = appState.startPoint, let endPoint = appState.endPoint {
            return LocalizedStringKey.destinationSelected
        } else {
            return LocalizedStringKey.specifyDestinationOnMap
        }
    }
    
    func destinationSelected() -> Bool {
        if let startPoint = appState.startPoint, let endPoint = appState.endPoint {
            return true
        } else {
            return false
        }
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
    NewJoiningRequestView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}

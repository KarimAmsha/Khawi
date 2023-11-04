//
//  JoiningToTripView.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI

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

    init(router: MainRouter) {
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
                        Text(LocalizedStringKey.rangeOfPrice)
                            .customFont(weight: .book, size: 12)
                            .foregroundColor(.primary())
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

                    CustomTextField(text: $note, placeholder: LocalizedStringKey.addOptionalNotes, textColor: .black4E5556(), placeholderColor: .grayA4ACAD())

                    Spacer()

                    Button {
                        if destinationSelected() {
                            router.replaceNavigationStack(path: [])
                            router.presentToastPopup(view: .joiningSuccess)
                        } else {
                            appState.toastTitle = LocalizedStringKey.error
                            appState.toastMessage = LocalizedStringKey.pleaseSpecifyStartPoint + "\n" + LocalizedStringKey.pleaseSpecifyEndPoint
                            router.presentToastPopup(view: .error)
                        }
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey.joinToTrip)
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
}

#Preview {
    JoiningToTripView(router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(AppState())
}

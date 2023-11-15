//
//  SelectDestinationView.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import MapKit

struct SelectDestinationView: View {
    @State private var startPointAddress: String = ""
    @State private var endPointAddress: String = ""
    @State private var selectedLocations: [CLLocationCoordinate2D] = []
    @StateObject private var router: MainRouter
    @State private var locations: [Mark] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 5,
            longitudeDelta: 5
        )
    )
    @State private var isSpecifyStartPoint = false
    @State private var isSpecifyEndPoint = false
    @EnvironmentObject var appState: AppState

    init(router: MainRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStringKey.tripPath)
                    .customFont(weight: .book, size: 16)
                    .foregroundColor(.gray4E5556())
                    .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        VStack {
                            Image("ic_start_point")
                                .resizable()
                                .frame(width: 20, height: 20)
                            if isSpecifyStartPoint {
                                Image("ic_v_line")
                                Image("ic_end_point")
                                    .resizable()
                                    .frame(width: 19, height: 30)
                            }
                        }

                        VStack(spacing: 20) {
                            HStack {
                                Text(startPointAddress.isEmpty ? LocalizedStringKey.startPoint : startPointAddress)
                                    .customFont(weight: .book, size: 16)
                                    .foregroundColor(isSpecifyStartPoint ? .black666666() : .grayA4ACAD())
                                    .lineLimit(1)
                                Spacer()
                                if isSpecifyStartPoint {
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 20, height: 20)
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

                            if isSpecifyStartPoint {
                                HStack {
                                    Text(endPointAddress.isEmpty ? LocalizedStringKey.endPoint : endPointAddress)
                                        .customFont(weight: .book, size: 16)
                                        .foregroundColor(isSpecifyEndPoint ? .black666666() : .grayA4ACAD())
                                        .lineLimit(1)
                                    Spacer()
                                    if isSpecifyStartPoint {
                                        Image("ic_edit")
                                            .resizable()
                                            .frame(width: 20, height: 20)
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
                            }
                        }
                    }
                }
                .padding(.leading, 44)
                .padding(.trailing, 24)
            }

            ZStack {
                Map(coordinateRegion: $region, annotationItems: locations) { location in
                    MapAnnotation(
                        coordinate: location.coordinate,
                        anchorPoint: CGPoint(x: 0.5, y: 0.7)
                    ) {
                        VStack{
                            if location.show {
                                Text(location.title)
                                    .customFont(weight: .bold, size: 14)
                                    .foregroundColor(.black131313())
                            }
                            Image(location.imageName)
                                .font(.title)
                                .foregroundColor(.red)
                                .onTapGesture {
                                    let index: Int = locations.firstIndex(where: {$0.id == location.id})!
                                    locations[index].show.toggle()
                                }
                        }
                    }
                }
                .onAppear {
                    moveToUserLocation()
                }

                Circle()
                    .fill(Color.redFF3F3F()
                    )
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                    // Add the "My Location" button at the bottom right
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                moveToUserLocation()
                            }) {
                                HStack {
                                    Image("ic_end_point")
                                        .resizable()
                                        .frame(width: 13, height: 20)
                                    Text(LocalizedStringKey.yourLocation)
                                        .customFont(weight: .bold, size: 12)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 110, height: 40)
                                .background(Color.white)
                                .cornerRadius(21)
                                .shadow(color: .black.opacity(0.28), radius: 2, x: 0, y: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 21.5)
                                        .inset(by: -0.5)
                                        .stroke(Color.primary(), lineWidth: 1)
                                )
                            }
                            Spacer()
                        }
                    }
                    .padding(.bottom, 135)
                    .padding(.horizontal, 16)

                    VStack {
                        Spacer()
                        VStack {
                            Button {
                                if destinationSelected() {
                                    router.navigateBack()
                                } else {
                                    if locations.count == 2 {
                                        // Calculate route or perform any other action here
                                        calculateRouteDirections()
                                        
                                        // Clear all locations to start fresh
                                        locations.removeAll()
                                    }
                                    // Append new location
                                    let newLocation = Mark(title: locations.isEmpty ? "Start" : "End", coordinate: region.center, show: true, imageName: locations.isEmpty ? "ic_start_point" : "ic_end_point")
                                    locations.append(newLocation)

                                    // Determine the button label and handle based on the locations count
                                    if locations.count == 1 {
                                        isSpecifyStartPoint = true
                                        isSpecifyEndPoint = false
                                    } else if locations.count == 2 {
                                        isSpecifyStartPoint = true
                                        isSpecifyEndPoint = true
                                        
                                        appState.startPoint = locations.first
                                        appState.endPoint = locations.last
                                    }
                                }
                                
                                handleAddressString()
                            } label: {
                                Text(!isSpecifyStartPoint ? LocalizedStringKey.specifyStartPoint : (isSpecifyStartPoint && !isSpecifyEndPoint) ? LocalizedStringKey.specifyEndPoint : LocalizedStringKey.joinToTrip)
                            }
                            .buttonStyle(PrimaryButton(fontSize: 18, fontWeight: .book, background: .primary(), foreground: .white, height: 48, radius: 12))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 19)
                        }
                        .background(Color.white)
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                    }
            }
        }
        .navigationTitle(LocalizedStringKey.specifyDestination)
    }
    
    private func calculateRouteDirections() {
        // Implement your logic to calculate route directions between selected locations
        print("Calculating route directions...")
    }
    
    func destinationSelected() -> Bool {
        return locations.count == 2
    }
    
    func handleAddressString() {
        guard let coordinate = locations.first?.coordinate else {
            // Handle the case where no locations are selected
            startPointAddress = ""
            endPointAddress = ""
            return
        }

        if locations.count == 1 {
            // Handle the case where one location is selected
            Utilities.getAddress(for: coordinate) { address in
                startPointAddress = address
            }
            endPointAddress = ""
        } else if locations.count == 2 {
            // Handle the case where two locations are selected
            Utilities.getAddress(for: locations[0].coordinate) { address in
                startPointAddress = address
            }
            Utilities.getAddress(for: locations[1].coordinate) { address in
                endPointAddress = address
            }
        } else {
            // Handle other cases if needed
            startPointAddress = ""
            endPointAddress = ""
        }
    }
    
    func moveToUserLocation() {
        withAnimation(.easeInOut(duration: 2.0)) {
            if let userLocation = LocationManager.shared.userLocation {
                region.center = userLocation
                region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            }
        }
    }
}

struct SelectDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDestinationView(router: MainRouter(isPresented: .constant(.main)))
            .environmentObject(AppState())
    }
}

//
//  HomeView.swift
//  Khawi
//
//  Created by Karim Amsha on 23.10.2023.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var appState: AppState
    @State var isEditing: Bool = false
    @State var searchText: String = ""
    @Binding var showPopUp: Bool
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @StateObject var tripsViewModel = TripsViewModel()
    @StateObject private var router: MainRouter
    
    init(showPopUp: Binding<Bool>, router: MainRouter) {
        _showPopUp = showPopUp
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                SearchBar(text: $searchText, placeholder: LocalizedStringKey.searchForPlace)
            }
            .padding()
            .background(showPopUp ? .clear : Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 2)

            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: tripsViewModel.filteredTrips) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Button(action: {
                        appState.selectedTrip = annotation
                        switch annotation.type {
                        case .joiningRequest:
                            router.presentToastPopup(view: .joining)
                        case .deliveryRequest:
                            router.presentToastPopup(view: .delivery)
                        case .none:
                            break
                        }
                    }) {
                        image(for: annotation.type ?? .joiningRequest)
                            .resizable()
                            .frame(width: 38, height: 47)
                    }
                }
            }
            .padding(.bottom, -20)
            .onAppear {
                region.center = tripsViewModel.allTrips[0].coordinate
            }
        }
        .ignoresSafeArea()
        .navigationTitle("")
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.gray595959())
                .opacity(showPopUp ? 0.3 : 0)
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    AsyncImage(url: settings.myUser.image?.toURL()) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Placeholder while loading
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
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
                    .background(Circle().foregroundColor(.white).padding(4).overlay(Circle().stroke(Color.primary(), lineWidth: 2)))
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Text(LocalizedStringKey.helloBrother)
                        .foregroundColor(.black141F1F())
                    Text("..\(settings.myUser.name ?? "")")
                        .foregroundColor(.primary())
                }
                .customFont(weight: .book, size: 20)
            }
        }
        .onAppear {
            // Initialize filteredTrips with the trips matching the default tab (Current Orders)
            filterTripsByStatus(.opened)
        }
    }
        
    func image(for type: RequestType) -> Image {
        switch type {
        case .joiningRequest:
            return Image("ic_car_pin")
        case .deliveryRequest:
            return Image("ic_person_pin")
        }
    }
    
    // Helper function to filter trips based on the selected tab
    private func filterTripsByStatus(_ status: OrderType) {
        tripsViewModel.filteredTrips = tripsViewModel.allTrips.filter { $0.status == .opened }
    }
}


#Preview {
    HomeView(showPopUp: .constant(false), router: MainRouter(isPresented: .constant(.main)))
        .environmentObject(UserSettings())
        .environmentObject(AppState())
}

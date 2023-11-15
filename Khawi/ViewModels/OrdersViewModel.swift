//
//  OrdersViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import SwiftUI
import MapKit
import Combine

class OrdersViewModel: ObservableObject {
    @Published var order: Order? = Order(id: nil, loc: nil, days: nil, passengers: nil, title: nil, f_lat: nil, f_lng: nil, t_lat: nil, t_lng: nil, max_price: nil, min_price: nil, price: nil, f_address: nil, t_address: nil, order_no: nil, tax: nil, totalDiscount: nil, netTotal: nil, status: nil, createAt: nil, dt_date: nil, dt_time: nil, is_repeated: nil, couponCode: nil, paymentType: nil, orderType: nil, max_passenger: nil, offers: nil, user: nil, notes: nil, canceled_note: nil)
    @Published var orderId: OrderId?
    @Published var orders: [Order] = []
    @Published var nearByOrders: [Order] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var errorTitle: String = LocalizedStringKey.error
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private let errorHandling: ErrorHandling
    private let dataProvider = DataProvider.shared
    @Published var userSettings = UserSettings.shared
    @Published var currentPage = 0
    @Published var totalPages = 1
    @Published var isFetchingMoreData = false
    @Published var pagination: Pagination?
    @Published var searchText: String = ""
    @Published var region: MKCoordinateRegion
    @Published var mapAnnotations: [CustomMapAnnotation] = []
    
    init(initialRegion: MKCoordinateRegion, errorHandling: ErrorHandling) {
        self.errorHandling = errorHandling
        self.region = initialRegion

        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                if searchText.count > 2 {
                    self.sendSearchRequestAndUpdateAnnotations(region: self.region, searchText: searchText)
                } else {
                    self.loadNearbyOrders(for: region.center)
                }
            }
            .store(in: &cancellables)
    }

    var shouldLoadMoreData: Bool {
        guard let totalPages = pagination?.totalPages else {
            return false
        }
        
        return currentPage < totalPages
    }

    func addOrder(params: [String: Any], onsuccess: @escaping (String, String) -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.addOrder(params: params, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<OrderId>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<OrderId>) in
                if response.status {
                    self?.orderId = response.items
                    self?.errorMessage = nil
                    onsuccess(response.items?._id ?? "", response.message)
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func addOfferToOrder(orderId: String, params: [String: Any], onsuccess: @escaping (String) -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.addOfferToOrder(orderId: orderId, params: params, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<Order>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<Order>) in
                if response.status {
                    self?.order = response.items
                    self?.errorMessage = nil
                    onsuccess(response.message)
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }

    func updateOfferStatus(orderId: String, params: [String: Any], onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.updateOfferStatus(orderId: orderId, params: params, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<Order>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<Order>) in
                if response.status {
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func updateOrderStatus(orderId: String, params: [String: Any], onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.updateOrderStatus(orderId: orderId, params: params, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<Order>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<Order>) in
                print("ooooo \(response)")
                if response.status {
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func getMap(params: [String: Any], onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        errorMessage = nil
        let endpoint = DataProvider.Endpoint.map(params: params, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: ArrayAPIResponse<Order>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: ArrayAPIResponse<Order>) in
                if response.status {
                    self?.nearByOrders = response.items ?? []
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
            })
            .store(in: &cancellables)
    }
    
    func getOrders(status: String?, page: Int?, limit: Int?) {
        guard let token = userSettings.token else {
            handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isFetchingMoreData = true
        errorMessage = nil

        let endpoint = DataProvider.Endpoint.getOrders(status: status, page: page, limit: limit, token: token)

        DataProvider.shared.request(endpoint: endpoint, responseType: OrdersApiResponse.self)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // Handle API error and update UI
                        self.handleAPIError(error)
                        self.isFetchingMoreData = false
                    }
                },
                receiveValue: { [weak self] (response: OrdersApiResponse) in
                    guard let self = self else { return }
                    isFetchingMoreData = false

                    if response.status_code == 200 {
                        if let items = response.items {
                            self.orders.append(contentsOf: items)
                            self.totalPages = response.pagenation?.totalPages ?? 1
                            self.pagination = response.pagenation
                        }
                        self.errorMessage = nil
                    } else {
                        // Handle API error and update UI
                        handleAPIError(.customError(message: response.message ?? ""))
                    }
                }
            )
            .store(in: &cancellables)
    }

    func loadMoreOrders(status: String?, limit: Int?) {
        guard !isFetchingMoreData, currentPage < totalPages else {
            // Don't fetch more data while a request is already in progress or no more pages available
            return
        }

        currentPage += 1
        getOrders(status: status, page: currentPage, limit: limit)
    }

    func getOrderDetails(orderId: String, onsuccess: @escaping () -> Void) {
        guard let token = userSettings.token else {
            self.handleAPIError(.customError(message: LocalizedStringKey.tokenError))
            return
        }

        isLoading = true
        errorMessage = nil
        let endpoint = DataProvider.Endpoint.getOrderDetails(orderId: orderId, token: token)
        
        DataProvider.shared.request(endpoint: endpoint, responseType: SingleAPIResponse<Order>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Use the centralized error handling component
                    self.handleAPIError(error)
                }
            }, receiveValue: { [weak self] (response: SingleAPIResponse<Order>) in
                print("ssss \(response)")
                if response.status {
                    self?.order = response.items
                    self?.errorMessage = nil
                    onsuccess()
                } else {
                    // Use the centralized error handling component
                    self?.handleAPIError(.customError(message: response.message))
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
}

extension OrdersViewModel {
    private func handleAPIError(_ error: APIClient.APIError) {
        let errorDescription = errorHandling.handleAPIError(error)
        errorMessage = errorDescription
    }
}

extension OrdersViewModel {
    func loadNearbyOrders(for location: CLLocationCoordinate2D) {
        let params = [
            "lat": location.latitude,
            "lng": location.longitude,
            "address": searchText
        ] as [String : Any]
//        nearByOrders.removeAll()
        getMap(params: params) {
            // Clear map annotations when loading new items
//            self.mapAnnotations.removeAll()

            // Update map annotations based on the new orders
            self.updateMapAnnotations()
        }
    }
    
    func sendSearchRequestAndUpdateAnnotations(region: MKCoordinateRegion, searchText: String) {
        let params = [
            "lat": region.center.latitude,
            "lng": region.center.longitude,
            "address": searchText
        ] as [String : Any]

//        nearByOrders.removeAll()
        getMap(params: params) {
            // Update the region based on the first order's coordinates if available
            if let firstOrder = self.nearByOrders.first,
               let latitude = firstOrder.f_lat,
               let longitude = firstOrder.f_lng {
                self.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }

            // Clear map annotations when loading new items
//            self.mapAnnotations.removeAll()

            // Update map annotations based on the new orders
            self.updateMapAnnotations()
        }
    }

    // Create a separate function to update map annotations
    private func updateMapAnnotations() {
        // Clear map annotations when loading new items
//        self.mapAnnotations.removeAll()

        // Add new map annotations
        self.mapAnnotations = self.generateMapAnnotations(for: self.nearByOrders, handleButtonTap: { _ in })
    }

    
    func image(for type: OrderType) -> Image {
        switch type {
        case .joining:
            return Image("ic_car_pin")
        case .delivery:
            return Image("ic_person_pin")
        }
    }
}

// Update OrdersViewModel to include map annotation logic
extension OrdersViewModel {
    // Update the generateMapAnnotations function
    func generateMapAnnotations(for orders: [Order], handleButtonTap: @escaping (Order) -> Void) -> [CustomMapAnnotation] {
        return orders.map { order in
            CustomMapAnnotation(
                id: order.id ?? "",
                coordinate: CLLocationCoordinate2D(latitude: order.f_lat ?? 0.0, longitude: order.f_lng ?? 0.0),
                content: AnyView(
                    Button(action: {
                        handleButtonTap(order)
                    }) {
                        if let type = order.type {
                            image(for: type)
                                .resizable()
                                .frame(width: 38, height: 47)
                        }
                    }
                )
            )
        }
    }
}


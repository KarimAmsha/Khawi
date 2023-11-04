//
//  Enum.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import Foundation

enum FontWeight: String {
    case bold            = "FFShamelFamily-SansOneBold"
    case book            = "FFShamelFamily-SansOneBook"
}

enum Language: String {
    case english
    case arabic
    
    var isRTL: Bool {
        self == .arabic
    }
}

enum UserType {
    case client
    case driver
}

enum MType: String, Codable {
    case photo
    case image
    case video
    case multi
    case media
    case text
    case none
    
    init(_ type: String) {
        switch type {
        case "photo" : self = .photo
        case "image" : self = .image
        case "video": self = .video
        case "multi": self = .multi
        case "media": self = .media
        case "text": self = .text
        case "none": self = .none
        default:
            self = .text
        }
    }

    var value : String {
        switch self {
        case .photo: return "photo"
        case .image: return "image"
        case .video: return "video"
        case .multi: return "multi"
        case .media: return "media"
        case .text: return "text"
        case .none: return "none"
        }
    }
}

enum MediaType {
    case multi
    case video
    case image
}

enum Page {
    case home
    case orders
    case notifications
    case settings
}

enum RequestType {
    case joiningRequest
    case deliveryRequest
    
    var value : String {
        switch self {
        case .joiningRequest: return LocalizedStringKey.joiningRequest
        case .deliveryRequest: return LocalizedStringKey.deliveryRequest
        }
    }
}

enum OrderType {
    case opened
    case completed
    case canceled
    
    var value : String {
        switch self {
        case .opened: return LocalizedStringKey.openedOrder
        case .completed: return LocalizedStringKey.completed
        case .canceled: return LocalizedStringKey.canceled
        }
    }
}

enum PopupView {
    case joining
    case delivery
    case deliverySuccess
    case joiningSuccess
    case review
    case error
    case createJoiningSuccess
    case createDeliverySuccess
}

enum PointType {
    case start
    case end
    case user
}

// Localization keys
enum LocalizedStringKey {
    static let switchToEnglish = "Switch to English".localized
    static let switchToArabic = "Switch to Arabic".localized
    static let noInternetConnection = "Internet Connection appears to be offline".localized
    static let shareYourPathWithOthers = "Share your path with others".localized
    static let gettingToYourDestinationIsEasier = "Getting to your destination is easier".localized
    static let investYourCar = "Invest your car".localized
    static let descriptionKey = "Through the availability of many cars you can easily find someone who will save you the time and trouble of transportation".localized
    static let next = "Next".localized
    static let createNewAccount = "Create New Account".localized
    static let enterYourPhoneNumberToCreateNewAccount = "Enter your phone number to create new account".localized
    static let register = "Register".localized
    static let enterCodeWasSentToYourMobileNumber = "Enter code was sent to your mobile number:".localized
    static let phoneNumber = "Phone Number".localized
    static let error = "Error".localized
    static let loading = "Loading".localized
    static let verifyCode = "Verify Code".localized
    static let resendCodeAfter = "Resend code after".localized
    static let personalInformation = "Personal Information".localized
    static let completeRegisteration = "Complete Registeration".localized
    static let fullName = "Full Name".localized
    static let email = "Email".localized
    static let areYouHaveCar = "Are you have a car".localized
    static let carType = "Car Type".localized
    static let carModel = "Car Model".localized
    static let carColor = "Car Color".localized
    static let carNumber = "Car Number".localized
    static let choosePhoto = "Choose Photo".localized
    static let takePhoto = "Take Photo".localized
    static let cancel = "Cancel".localized
    static let ok = "Ok".localized
    static let home = "Home".localized
    static let orders = "Orders".localized
    static let notifications = "Notifications".localized
    static let settings = "Settings".localized
    static let helloBrother = "Hello Brother".localized
    static let searchForPlace = "Search for place".localized
    static let joiningRequest = "Joining Request".localized
    static let deliveryRequest = "Delivery Request".localized
    static let currentOrders = "Current Orders".localized
    static let completedOrders = "Completed Orders".localized
    static let cancelledOrders = "Cancelled Orders".localized
    static let tripNumber = "Trip Number".localized
    static let from = "From".localized
    static let to = "To".localized
    static let openedOrder = "Opened Order".localized
    static let completed = "Completed".localized
    static let canceled = "Canceled".localized
    static let showDetails = "Show Details".localized
    static let carInformation = "Car Information".localized
    static let tripDate = "Trip Date".localized
    static let dateOfTheFirstTrip = "Date Of The First Trip".localized
    static let newPassenger = "New Passenger".localized
    static let agreeOnJoining = "Agree On Joining".localized
    static let orderDetails = "Order Details".localized
    static let showOnMap = "Show On Map".localized
    static let tripDays = "Trip Day".localized
    static let driverInformations = "Driver Informations".localized
    static let numberOfAvailableSeats = "Number of available seats".localized
    static let numberOfRequiredSeats = "Number of required seats".localized
    static let driverNotes = "Driver Notes".localized
    static let notes = "Notes".localized
    static let joinNow = "Join Now".localized
    static let makeDeliveryOffer = "Make a delivery offer".localized
    static let deliveryOffer = "Delivery Offer".localized
    static let minPrice = "Min Price".localized
    static let maxPrice = "Max Price".localized
    static let addOptionalNotes = "Add note (Optional)".localized
    static let deliveryOfferSuccess = "Delivery offer has been successfully submitted".localized
    static let joiningSuccess = "Joining request has been successfully submitted".localized
    static let showRequestDetails = "Show Request Details".localized
    static let addReview = "Add Review".localized
    static let joinToTrip = "Join To Trip".localized
    static let selectDetination = "Select the destination on the map".localized
    static let specifyPrice = "Specify the price".localized
    static let rangeOfPrice = "The price should be between (25-100 SAR)".localized
    static let isDailyTrip = "Is the trip daily?".localized
    static let tripTime = "Trip Time".localized
    static let tripPath = "Trip Path".localized
    static let startPoint = "Start Point".localized
    static let endPoint = "End Point".localized
    static let specifyStartPoint = "Specify Start Point".localized
    static let specifyEndPoint = "Specify End Point".localized
    static let specifyDestination = "Specify Destination".localized
    static let pleaseSpecifyStartPoint = "Please Specify Start Point".localized
    static let pleaseSpecifyEndPoint = "Please Specify End Point".localized
    static let destinationSelected = "Destination has been selected".localized
    static let done = "Done".localized
    static let profile = "Profile".localized
    static let saveChanges = "Save Changes".localized
    static let wallet = "Wallet".localized
    static let aboutUs = "About Us".localized
    static let contactUs = "Contact Us".localized
    static let shareApp = "Share App".localized
    static let termsConditions = "Terms And Conditions".localized
    static let logout = "Logout".localized
    static let myWallet = "My Wallet".localized
    static let lastTransaction = "Last Transaction".localized
    static let totalAccount = "Total Account".localized
    static let sar = "SAR".localized
    static let finicialTransactions = "Finicial Transactions".localized
    static let addAccount = "Add Account".localized
    static let tripTitle = "Trip Title".localized
    static let firstTripDate = "First Trip Date".localized
    static let maxPassengersNumber = "Maximum number of passengers per flight".localized
    static let submitJoinRequest = "Submit Join Request".localized
    static let joinRequestSuccess = "Joining request created successfully".localized
    static let joiningRequests = "Joining Requests".localized
    static let price = "Price".localized
    static let requestAccept = "Request Accept".localized
    static let requestReject = "Request Reject".localized
    static let passengersCount = "Passengers Count".localized
    static let agreeOn = "Agree On".localized
    static let specifyDestinationOnMap = "Specify Destination On Map".localized
    static let submitDeliveryRequest = "Submit Delivery Request".localized
    static let deliveryRequestSuccess = "Delivery request created successfully".localized
    static let yourLocation = "Your Location".localized
}

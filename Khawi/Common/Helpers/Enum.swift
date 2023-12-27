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

enum OrderType: Int, Codable {
    case joining = 1
    case delivery = 2
    
    init(_ type: Int) {
        switch type {
        case 1: self = .joining
        case 2: self = .delivery
        default:
            self = .joining
        }
    }
    
    var value: String {
        switch self {
        case .joining: return LocalizedStringKey.joiningRequest
        case .delivery: return LocalizedStringKey.deliveryRequest
        }
    }
}

enum OrderStatus: String, Codable {
    case new = "new"
    case accepted = "accepted"
    case started = "started"
    case finished = "finished"
    case canceledByDriver = "canceled_by_driver"
    case canceledByUser = "canceled_by_user"
    case canceled  = "canceled"
    case rated  = "rated"

    init(_ type: String) {
        switch type {
        case "new" : self = .new
        case "accepted" : self = .accepted
        case "started" : self = .started
        case "finished" : self = .finished
        case "canceled_by_driver" : self = .canceledByDriver
        case "canceled_by_user" : self = .canceledByUser
        case "canceled": self = .canceled
        case "rated": self = .rated
        default:
            self = .new
        }
    }

    var value: String {
        switch self {
        case .new: return LocalizedStringKey.currentOrder
        case .accepted: return LocalizedStringKey.accepted
        case .started: return LocalizedStringKey.started
        case .finished: return LocalizedStringKey.finished
        case .canceledByDriver: return LocalizedStringKey.canceledByDriver
        case .canceledByUser: return LocalizedStringKey.canceledByUser
        case .canceled: return LocalizedStringKey.canceled
        case .rated: return LocalizedStringKey.completed
        }
    }
    
    var displayedValue: String {
        switch self {
        case .new: return LocalizedStringKey.openedOrder
        case .accepted: return LocalizedStringKey.openedOrder
        case .started: return LocalizedStringKey.openedOrder
        case .finished: return LocalizedStringKey.completed
        case .canceled: return LocalizedStringKey.canceledOrder
        case .canceledByDriver: return LocalizedStringKey.canceledByDriver
        case .canceledByUser: return LocalizedStringKey.canceledByUser
        case .rated: return LocalizedStringKey.completed
        }
    }
    
    var displayedStatusValue: String {
        switch self {
        case .new: return LocalizedStringKey.new
        case .accepted: return LocalizedStringKey.accepted
        case .finished: return LocalizedStringKey.completed
        case .started: return LocalizedStringKey.started
        case .canceledByDriver: return LocalizedStringKey.canceledByDriver
        case .canceledByUser: return LocalizedStringKey.canceledByUser
        case .canceled: return LocalizedStringKey.canceledOrder
        case .rated: return LocalizedStringKey.completed
        }
    }
}

enum OfferStatus: String, Codable {
    case addOffer = "add_offer"
    case acceptOffer = "accept_offer"
    case rejectOffer = "reject_offer"
    case attend  = "attend"
    case notAttend  = "not_attend"
}

enum PopupView: Hashable {
    case joining(Order)
    case delivery(Order)
    case deliverySuccess(String, String)
    case joiningSuccess(String, String)
    case review(Order)
    case error(String, String)
    case createJoiningSuccess(String, String)
    case createDeliverySuccess(String, String)
    case alert(AlertModel)
    case inputAlert(AlertModelWithInput)
}

enum PointType {
    case start
    case end
    case user
}

// Define the enum for the 'type' property
enum TransactionType: String, Codable {
    case addition = "+"
    case subtraction = "-"
}

enum NotificationType: String, Codable {
    case orders = "1"
    case panel = "2"

    init(_ type: String) {
        switch type {
        case "1": self = .orders
        case "2": self = .panel
        default:
            self = .panel
        }
    }
}

enum NOTIFICATION_TYPE: Int {
    case ORDERS = 1
    case COUPON = 2
    case GENERAL = 3
}

// Localization keys
enum LocalizedStringKey {
    static let switchToEnglish = "Switch to English".localized
    static let switchToArabic = "Switch to Arabic".localized
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
    static let currentOrder = "Current Order".localized
    static let new = "New".localized
    static let finished = "finished".localized
    static let canceled = "canceled".localized
    static let openedOrder = "Opened Order".localized
    static let completed = "Completed".localized
    static let canceledOrder = "Canceled".localized
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
    static let personInformations = "Person Informations".localized
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
    static let rangeOfPrice = "The price should be between".localized
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
    static let tripTitleOptional = "Trip Title Optional".localized
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
    static let tokenError = "Error With Token".localized
    static let logoutMessage = "Are you sure you want to logout!.".localized
    static let message = "Message".localized
    static let agreeOnTerms = "Please agree on terms and conditions".localized
    static let successfullyUpdated = "Successfully Updated".localized
    static let seats = "Seats".localized
    static let deliveryOffers = "Delivery Offers".localized
    static let accepted = "Accepted".localized
    static let accept = "Accept".localized
    static let started = "Started".localized
    static let start = "Start".localized
    static let finish = "Finish".localized
    static let canceledByDriver = "Canceled By Driver".localized
    static let canceledByUser = "Canceled By User".localized
    static let attend = "Attend".localized
    static let notAttend = "Not Attend".localized
    static let description = "Description".localized
    static let cancellationReason = "Cancellation Reason".localized
    static let send = "Send".localized
    static let delete = "Delete".localized
    static let deleteMessage = "Are you sure you want to delete this item!..".localized
    static let orderNo = "Order No".localized
    static let payWithCard = "Pay with Card".localized
    static let payWithApplePay = "Pay with Apple Pay".localized
    static let amount = "Amount".localized
    static let exceedsLimits = "Exceeds Limits".localized
    static let acceptedOffers = "Accepted Offers".localized
    static let yourCountry = "Your country".localized
    static let coupon = "Coupon".localized
    static let inviteFriend = "Invite Friend".localized
    static let carFrontImage = "Car Front Image".localized
    static let carBackImage = "Car Back Image".localized
    static let carRightImage = "Car Right Image".localized
    static let carLeftImage = "Car Left Image".localized
    static let identityImage = "Identity Image".localized
    static let licenseImage = "License Image".localized
    static let youDontHaveCar = "You don't have a car".localized
    static let approvedSoon = "Your account will be approved soon".localized
    static let callInfo = "Call Info".localized
    static let clickToCall = "Click to call".localized
}

enum LocalizedError {
    static let noInternetConnection = "No internet connection. Please check your network.".localized
    static let unknownNetworkError = "An unknown network error occurred.".localized
    static let badRequest = "Bad request. Please check your input.".localized
    static let unauthorized = "Unauthorized. Please log in.".localized
    static let resourceNotFound = "Resource not found.".localized
    static let serverError = "Server error. Please try again later.".localized
    static let unknownError = "An unknown error occurred.".localized
    static let invalidData = "Invalid data received.".localized
    static let decodingError = "Decoding error".localized
    static let invalidURL = "Invalid URL".localized
    static let invalidToken = "Invalid Token".localized
    static let responseValidationFailed = "Response validation failed".localized
}

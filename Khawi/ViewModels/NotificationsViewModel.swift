//
//  NotificationsViewModel.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import Foundation
import SwiftUI

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = (1...10).map { index in
        Notification(
            name: "احمد محمد علي",
            date: "08.58",
            title: index % 2 == 0 ? "هذا اشعار خاص بالإدارة" : (index % 5 == 0 ? "موافقة على الانضمام" : "راكب جديد"),
            message: index % 2 == 0 ? "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص." : (index % 5 == 0 ? "وافق على انضمامك لرحلته" : "يطلب الانضمام إلى رحلتك."),
            isFromAdmin: index % 2 == 0, // Alternate between admin and user
            requestType: index % 5 == 0 ? .deliveryRequest : .joiningRequest // Alternate request type
        )
    }

}

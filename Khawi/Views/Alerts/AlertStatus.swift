//
//  AlertStatus.swift
//  GatherPoint
//
//  Created by Karim Amsha on 8.09.2023.
//

import SwiftUI

class SomeItem: Equatable {
    
    let value: String
    
    init(value: String) {
        self.value = value
    }
    
    static func == (lhs: SomeItem, rhs: SomeItem) -> Bool {
        lhs.value == rhs.value
    }
}

struct FloatsStateBig {
    var showingTopLeading = false
    var showingTop = false
    var showingTopTrailing = false

    var showingLeading = false
    // center is a regular popup
    var showingTrailing = false

    var showingBottomLeading = false
    var showingBottom = false
    var showingBottomTrailing = false
}

struct FloatsStateSmall {
    var showingTopFirst = false
    var showingTopSecond = false
    var showingBottomFirst = false
    var showingBottomSecond = false
}

struct ToastsState {
    var showingTopFirst = false
    var showingTopSecond = false
    var showingBottomFirst = false
    var showingBottomSecond = false
    var showingSuccess = false
}

struct PopupsState {
    var middleItem: SomeItem?
    var showingBottomFirst = false
    var showingBottomSecond = false
}

struct ActionSheetsState {
    var showingFirst = false
    var showingSecond = false
}


//
//  Pagination.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import Foundation

struct Pagination: Codable {
    let size: Int?
    let totalElements: Int?
    let totalPages: Int?
    let pageNumber: Int?
}

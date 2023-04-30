//
//  ProductOfList.swift
//  TestSpira
//
//  Created by Pedro Alonso Daza B on 30/04/23.
//

import Foundation
// MARK: - ProductOfList
struct ProductOfList: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let description, category: String?
    let image: String?
    let rating: Rating?
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}

//
//  LocationModel.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation
// MARK: - LocationModel
struct LocationModel: Codable {
    let data: Inter?
}
// MARK: - LocationModel
struct Inter: Codable {
    let data: [Datum]?
}
// MARK: - Datum
struct Datum: Codable {
    let idRecipe: Int?
    let lat, lot: Double?
}

//
//  LocationsRecipeData.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation
class LocationsWS {
    static func getLocationRecipe(complete: @escaping ((Bool, LocationModel?, String) -> Void)) {
        let url = getBASE_UREL() + "/yape/api/getLocationsRecipes"
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: ["":""], modelType: LocationModel.self) { success, locationModel, error in
            DispatchQueue.main.async {
                complete(success, locationModel, error?.localizedDescription ?? "")
            }
        }
    }
}

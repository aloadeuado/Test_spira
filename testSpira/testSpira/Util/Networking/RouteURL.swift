//
//  RouteURL.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation

func getStringOfInfo(key:String) -> String{
    
    if let value = Bundle.main.object(forInfoDictionaryKey: key) {
        if let stringValue = value as? String {
            return stringValue
        }
    }
    
    return ""
     
}

func getListProducstUrl() -> String {
    return getStringOfInfo(key: "URL_LIST_PRODUCTS")
}

func getDetailProductUrl() -> String {
    return getStringOfInfo(key: "URL_DETAIL_PRODUCT")
}

func getGoogleKey() -> String {
    return getStringOfInfo(key: "google_key")
}

func getBASE_UREL() -> String {
    return getStringOfInfo(key: "BASE_UREL")
}

func getUrlApod() -> String {
    return "https://api.nasa.gov/planetary/apod" + "?api_key=" + "m9loOd79vKI0ArBwtmhX2gOGRQbIMi7vNttpIzaR&date={date}"
}

//
//  Resources.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 30.10.2022.
//

import UIKit

typealias R = Resources

enum Resources {
    enum Numbers {
        static let cacheTimeInSeconds: Double = 3600
        static let connectionStatusTime: Double = 1
        static let rowHeight: CGFloat = 140
    }
    
    enum Strings {
        static let title = "Avito Employees"
        static let refresh = "arrow.clockwise"
        
        static let warning = "Warning!"
        static let connected = "Connected"
        static let notConnected = "Not Connected"
        static let noInternet = "No Internet Connection"
        static let tryAgainLater = "Please try again later"
        static let tryAgain = "Try Again"
        static let ok = "OK"
        
        static let avatar = "person.circle"
        static let separator = ", "
        static let name = "Name: "
        static let phone = "Phone: "
        static let skills = "Skills: "
        
        static let changeConnectionNotification = "changeConnectionNotification"
        static let customQueue = "customQueue"
        static let baseURL = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    }
    
    enum Fonts {
        static func makeFont(size: CGFloat = 24, weight: UIFont.Weight) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
}

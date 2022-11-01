//
//  AvitoModel.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 30.10.2022.
//

import Foundation

struct AvitoModel: Codable {
    let company: Company
}

struct Company: Codable {
    let name: String
    let employees: [Employee]
}

struct Employee: Codable {
    let name, phoneNumber: String
    let skills: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}

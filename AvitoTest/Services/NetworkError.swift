//
//  NetworkError.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 31.10.2022.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "Invalid URL"
    case emptyData = "Empty Data"
    case decodingFailed = "Decoding Failed"
    case noConnection = "No Internet Connection"
}

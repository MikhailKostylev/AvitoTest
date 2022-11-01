//
//  NetworkService.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 30.10.2022.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    var dataIsCached: Bool { get }
    func fetchingData(completion: @escaping (Result<AvitoModel, NetworkError>) -> Void)
    func removeCache()
}

final class NetworkService: NetworkProtocol {
    
    public var dataIsCached = false
    
    private let baseURL = R.Strings.baseURL
    private let cacheTime = R.Numbers.cacheTimeInSeconds
}

// MARK: - Public

extension NetworkService {
    public func fetchingData(completion: @escaping (Result<AvitoModel, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        if let validData = getDataFromCache(for: url) {
            dataIsCached = true
            completion(.success(validData))
            return
        }
        
        getData(for: url, completion: completion)
    }
    
    public func removeCache() {
        guard let url = URL(string: baseURL) else { return }
        let request = URLRequest(url: url)

        DispatchQueue.main.asyncAfter(deadline: .now() + cacheTime) {
            URLCache.shared.removeCachedResponse(for: request)
        }
    }
}

// MARK: - Private

private extension NetworkService {
    func getData(for url: URL, completion: @escaping (Result<AvitoModel, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if error != nil {
                completion(.failure(NetworkError.noConnection))
                return
            }
            
            guard let data = data, let response = response else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            self.saveDataToCache(with: data, and: response)
            
            guard let decodingData = self.decodeData(AvitoModel.self, data) else {
                completion(.failure(NetworkError.decodingFailed))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(decodingData))
            }
        }.resume()
    }
    
    func decodeData<T: Codable>(_ type: T.Type, _ data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let descriptionData = try decoder.decode(type, from: data)
            return descriptionData
        } catch {
            print(NetworkError.decodingFailed.rawValue, error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Cache
    
    func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    func getDataFromCache(for url: URL) -> AvitoModel? {
        let request = URLRequest(url: url)
        
        guard
            let cacheResponse = URLCache.shared.cachedResponse(for: request),
            let decodingData = decodeData(AvitoModel.self, cacheResponse.data)
        else  {
            return nil
        }
        
        return decodingData
    }
}

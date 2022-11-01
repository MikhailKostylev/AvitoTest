//
//  NetworkMonitor.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 31.10.2022.
//

import Foundation
import Network

protocol NetworkMonitorProtocol: AnyObject {
    var delegate: NetworkMonitorDelegate? { get set }
    var isConnected: Bool { get }
}

protocol NetworkMonitorDelegate: AnyObject {
    func trackingNetworkConnection()
}

final class NetworkMonitor: NetworkMonitorProtocol {
    
    public weak var delegate: NetworkMonitorDelegate?
    
    public  var isConnected: Bool = false {
        didSet {
            delegate?.trackingNetworkConnection()
        }
    }
      
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
}

// MARK: - Public

extension NetworkMonitor {
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {  path in
            self.isConnected = path.status != .unsatisfied
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}

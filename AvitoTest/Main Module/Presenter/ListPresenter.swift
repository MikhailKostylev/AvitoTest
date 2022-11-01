//
//  ListPresenter.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 01.11.2022.
//

import Foundation

protocol ListPresenterOutput: AnyObject {
    var employees: [Employee] { get }
    func trackingNetworkConnection()
    func fetchData()
}

final class ListPresenter: ListPresenterOutput {
    
    public weak var view: ListViewInput!
    public var networkService: NetworkProtocol!
    public var networkMonitor: NetworkMonitorProtocol!
    
    public var employees = [Employee]() {
        didSet {
            view.changeNoInternetLabel()
            view.changeSpinnerDisplay()
        }
    }
    
    init(
        viewController: ListViewInput,
        networkService: NetworkProtocol,
        networkMonitor: NetworkMonitorProtocol
    ) {
        self.view = viewController
        self.networkService = networkService
        self.networkMonitor = networkMonitor
    }
}

// MARK: - Network Monitor Delegate

extension ListPresenter: NetworkMonitorDelegate {
    func trackingNetworkConnection() {
        networkMonitor.delegate = self
        if networkMonitor.isConnected {
            fetchData()
            view.dismissAlert()
        } else {
            view.showNotConnectedStatus()
            view.showTryAgainAlert()
        }
    }
}

// MARK: - Network

extension ListPresenter {
    func fetchData() {
        networkService.fetchingData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let sortedEmployees = self.sortedEmployees(from: data)
                self.employees = sortedEmployees
                self.displayConnectionStatus()
                self.view.reloadTableView()
                
            case .failure(let error):
                self.view.reloadTableView()
                self.view.showFailureAlert(with: error)
            }
            
            self.networkService?.removeCache()
        }
    }
}

// MARK: - Private

private extension ListPresenter {
    func sortedEmployees(from data: AvitoModel) -> [Employee] {
        return data.company.employees.sorted { $0.name < $1.name }
    }
    
    func displayConnectionStatus() {
        if networkMonitor.isConnected {
            view.showConnectedStatus()
        } else {
            view.showNotConnectedStatus()
            if !networkService.dataIsCached {
                view.showTryAgainAlert()
            }
        }
    }
}



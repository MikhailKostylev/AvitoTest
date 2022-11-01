//
//  Assembly.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 31.10.2022.
//

import UIKit

final class Assembly {
    public func configureMainModule() -> UIViewController {
        let networkService = NetworkService()
        let networkMonitor = NetworkMonitor()
        let view = ListViewController()
        let presenter = ListPresenter(
            viewController: view,
            networkService: networkService,
            networkMonitor: networkMonitor
        )
        
        view.presenter = presenter
        presenter.view = view
        
        networkMonitor.startMonitoring()
        
        return view
    }
}

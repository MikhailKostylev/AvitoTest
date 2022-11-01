//
//  ListViewController.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 29.10.2022.
//

import UIKit

protocol ListViewInput: AnyObject {
    func changeNoInternetLabel()
    func changeSpinnerDisplay()
    func reloadTableView()
    func showFailureAlert(with error: NetworkError)
    func showConnectedStatus()
    func showNotConnectedStatus()
    func showTryAgainAlert()
    func dismissAlert()
}

final class ListViewController: UIViewController, ListViewInput {
    
    public var presenter: ListPresenterOutput!
    
    // MARK: - UI elements
    
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.rowHeight = R.Numbers.rowHeight
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .systemGray
        view.style = .large
        view.startAnimating()
        return view
    }()
    
    private let noInternetLabel: UILabel = {
        let view = UILabel()
        view.font = R.Fonts.makeFont(size: 20, weight: .light)
        view.text = R.Strings.noInternet
        view.textColor = .systemGray
        view.isHidden = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.trackingNetworkConnection()
        setupVC()
        setupRefreshBarButton()
        addSubviews()
        setupRefreshControl()
        setupTableView()
        setupLayout()
    }
}

// MARK: - Actions

extension ListViewController {
    @objc func refresh() {
        presenter?.fetchData()
    }
    
    @objc func didPullToRefresh(sender: UIRefreshControl) {
        presenter?.fetchData()
        DispatchQueue.main.async {
            sender.endRefreshing()
        }
    }
    
    func changeNoInternetLabel() {
        DispatchQueue.main.async {
            self.noInternetLabel.isHidden = !self.presenter.employees.isEmpty
        }
    }
    
    func changeSpinnerDisplay() {
        DispatchQueue.main.async {
            self.presenter.employees.isEmpty
            ? self.spinner.startAnimating()
            : self.spinner.stopAnimating()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.animateTableView()
        }
    }
    
    func showFailureAlert(with error: NetworkError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + R.Numbers.connectionStatusTime) {
            self.presentAlert(
                title: error.rawValue,
                message: R.Strings.tryAgainLater,
                buttonTitle: R.Strings.ok,
                style: .actionSheet
            )
        }
    }
    
    func showConnectedStatus() {
        DispatchQueue.main.async {
            self.title = R.Strings.connected
            self.navigationController?.navigationBar.backgroundColor = .systemGreen
            
            DispatchQueue.main.asyncAfter(deadline: .now() + R.Numbers.connectionStatusTime) {
                self.title = R.Strings.title
                self.navigationController?.navigationBar.backgroundColor = .systemBackground
            }
        }
    }
    
    func showNotConnectedStatus() {
        DispatchQueue.main.async {
            self.title = R.Strings.notConnected
            self.navigationController?.navigationBar.backgroundColor = .systemOrange
        }
    }
    
    func showTryAgainAlert() {
        DispatchQueue.main.async {
            self.presentAlert(
                title: R.Strings.warning,
                message: R.Strings.noInternet,
                buttonTitle: R.Strings.tryAgain,
                style: .alert) { _ in self.presenter.fetchData() }
        }
    }
    
    func dismissAlert() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Setups

private extension ListViewController {
    func setupVC() {
        title = R.Strings.notConnected
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupRefreshBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: R.Strings.refresh),
            style: .done,
            target: self,
            action: #selector(refresh)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.addSubview(noInternetLabel)
    }
    
    func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            EmployeeCell.self,
            forCellReuseIdentifier: EmployeeCell.id
        )
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = .secondaryLabel
        refreshControl.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
    }
    
    func setupLayout() {
        tableView.prepareForAutoLayout()
        spinner.prepareForAutoLayout()
        noInternetLabel.prepareForAutoLayout()
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noInternetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noInternetLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - Table DataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmployeeCell.id,
            for: indexPath
        ) as? EmployeeCell else { return UITableViewCell() }
        let model = presenter.employees[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

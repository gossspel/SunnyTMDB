//
//  MovieSearchVC.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/13/21.
//

import UIKit

class MovieSearchVC: UIViewController {
    private let presenter: MovieSearchPresenterProtocol
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    private let cellOuterPadding: CGFloat = 16
    private let cellPosterHeight: CGFloat = 150
    
    init(presenter: MovieSearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MovieSearchViewProtocol Conformation

extension MovieSearchVC: MovieSearchViewProtocol {
    func refreshTable() {
        tableView.reloadData()
    }
}

// MARK: - View Controller Life Cycle

extension MovieSearchVC {
    // TODO: use tableView's backgroundView to display the empty view (search for a movie prompt)
    
    override func loadView() {
        super.loadView()
        // TODO: finish this
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        presenter.doInitialSetup()
    }
}

// MARK: - View Setup

extension MovieSearchVC {
    private func loadTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = cellOuterPadding * 2 + cellPosterHeight
        
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: presenter.cellReuseID)
        tableView.dataSource = self
        
        // NOTE: Eliminate extra separators below UITableView
        // LINK: https://stackoverflow.com/a/5377569
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
    }
    
    private func loadSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.isActive = true
    }
}

// MARK: - UISearchBarDelegate Conformation

extension MovieSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: do delay search in presenter using https://stackoverflow.com/a/48666001
    }
}

// MARK: - UITableViewDataSource Conformation

extension MovieSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: finish this
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: finish this
        return UITableViewCell()
    }
}

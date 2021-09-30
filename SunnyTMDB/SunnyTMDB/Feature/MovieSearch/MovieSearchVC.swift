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
    private let emptyTableLabel: UILabel = UILabel()
    
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
    var emptyTableLabelObject: LabelProtocol {
        return emptyTableLabel
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
    
    func updateVisibilityOfTableBackgroundView(setIsHidden: Bool) {
        self.tableView.backgroundView = setIsHidden ? nil : emptyTableLabel
    }
    
    func doBatchOperationsInTable(indexPathsToDelete: [IndexPath], indexPathsToInsert: [IndexPath]) {
        guard !indexPathsToDelete.isEmpty || !indexPathsToInsert.isEmpty else {
            return
        }
        
        tableView.performBatchUpdates { [weak self] in
            if !indexPathsToDelete.isEmpty {
                self?.tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
            }
            
            if !indexPathsToInsert.isEmpty {
                self?.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
            }
        }
    }
}

// MARK: - View Controller Life Cycle

extension MovieSearchVC {
    override func loadView() {
        super.loadView()
        loadSubviews()
        activateLayoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        presenter.doInitialSetup()
    }
}

// MARK: - View Setup

extension MovieSearchVC {
    private func loadSubviews() {
        loadSearchController()
        loadTableView()
        loadEmptyTableLabel()
    }
    
    private func loadTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = cellOuterPadding * 2 + cellPosterHeight
        
        for cellType in MovieSearchTableCellType.allCases {
            cellType.registerResusableCell(tableView: tableView)
        }
        
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
    
    private func loadEmptyTableLabel() {
        emptyTableLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTableLabel.textAlignment = .center
        view.addSubview(emptyTableLabel)
    }
}

// MARK: - Auto Layout Setup

extension MovieSearchVC {
    private var views: [String: UIView] {
        let dict: [String: UIView] = ["table": tableView]
        return dict
    }
    
    private var allLayoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += tableViewVConstraints
        constraints += tableViewHConstraints
        return constraints
    }
    
    private var tableViewVConstraints: [NSLayoutConstraint] {
        let VFLStr: String = "V:|[tableView]|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var tableViewHConstraints: [NSLayoutConstraint] {
        let VFLStr: String = "H:|[tableView]|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private func activateLayoutConstraints() {
        NSLayoutConstraint.activate(allLayoutConstraints)
    }
}

// MARK: - UISearchBarDelegate Conformation

extension MovieSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.handleSearchBarTextDidChange(searchText: searchText)
    }
}

// MARK: - UITableViewDataSource Conformation

extension MovieSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = presenter.getCellTypeAtIndexPath(indexPath: indexPath)
        let cellReusedID = presenter.getCellReuseIDAtIndexPath(indexPath: indexPath)
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellReusedID, for: indexPath)
        
        switch cellType {
        case .loadingCell:
            return dequeuedCell
        case .movieCell:
            guard let movieCell = dequeuedCell as? MovieListTableViewCellProtocol else {
                return dequeuedCell
            }
            
            let updatedMovieCell = presenter.getUpdatedMovieCell(cell: movieCell, indexPath: indexPath)
            
            guard let updatedUIKitMovieCell = updatedMovieCell as? MovieListTableViewCell else {
                return dequeuedCell
            }
            
            return updatedUIKitMovieCell
        }
    }
}

// MARK: - UITableViewDelegate Conformation

extension MovieSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.handleWillDisplayCellAtIndexPath(indexPath: indexPath)
    }
}

// MARK: - UIKit Related Extension of MovieSearchTableCellType

private extension MovieSearchTableCellType {
    func registerResusableCell(tableView: UITableView) {
        tableView.register(cellClassType, forCellReuseIdentifier: cellReuseID)
    }
    
    var cellClassType: AnyClass {
        switch self {
        case .loadingCell:
            return LoadingTableViewCell.self
        case .movieCell:
            return MovieListTableViewCell.self
        }
    }
}

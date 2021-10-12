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
    func updateEmptyTableLabelText(text: String) {
        self.emptyTableLabel.text = text
    }
    
    func refreshTable() {
        self.tableView.reloadData()
    }
    
    func doBatchOperationsInTable(indexPathsToDelete: [IndexPath], indexPathsToInsert: [IndexPath]) {
        DispatchQueue.main.async {
            guard !indexPathsToDelete.isEmpty || !indexPathsToInsert.isEmpty else {
                return
            }
            
            let updateOperations: () -> Void = { [weak self] in
                if !indexPathsToDelete.isEmpty {
                    self?.tableView.deleteRows(at: indexPathsToDelete, with: .fade)
                }
                
                if !indexPathsToInsert.isEmpty {
                    self?.tableView.insertRows(at: indexPathsToInsert, with: .fade)
                }
            }
            
            self.tableView.performBatchUpdates(updateOperations)
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
        loadEmptyTableLabel()
        loadTableView()
    }
    
    private func loadTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        
        // NOTE: Setting the estimatedRowHeight is necessary for the tableView delegate to behave properly
        // LINK: https://stackoverflow.com/a/57249122
        tableView.estimatedRowHeight = 600
        
        // NOTE: Have to do manual contentInset adjustment because of white space on top of UITableView issue
        // LINK: https://stackoverflow.com/q/39318740
        tableView.contentInsetAdjustmentBehavior = .never
        
        // NOTE: Eliminate extra separators below UITableView
        // LINK: https://stackoverflow.com/a/5377569
        tableView.tableFooterView = UIView(frame: .zero)
        
        for cellType in MovieSearchTableCellType.allCases {
            cellType.registerResusableCell(tableView: tableView)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func loadSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func loadEmptyTableLabel() {
        emptyTableLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTableLabel.textAlignment = .center
        view.addSubview(emptyTableLabel)
    }
    
    private func updateTableViewContentInsetWithSearchBarInNavBar() {
        let statusBarHeight: CGFloat = view.window?.safeAreaInsets.top ?? 0
        let searchBarInNavBarHeight: CGFloat = searchController.searchBar.bounds.height
        let totalHeight: CGFloat = statusBarHeight + searchBarInNavBarHeight
        self.tableView.contentInset = UIEdgeInsets(top: totalHeight, left: 0, bottom: 0, right: 0)
    }
    
    private func updateTableViewContentInsetWithSearchBarBelowNavBar() {
        let statusBarHeight: CGFloat = view.window?.safeAreaInsets.top ?? 0
        
        // NOTE: navigationController?.navigationBar.bounds.height is sometimes inaccurate with UISearchController,
        // creating extra inset space, so we are using 44 here instead.
        let navBarHeight: CGFloat = 44
        
        let searchBarHeight: CGFloat = searchController.searchBar.bounds.height
        let totalHeight: CGFloat = statusBarHeight + navBarHeight + searchBarHeight
        self.tableView.contentInset = UIEdgeInsets(top: totalHeight, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Auto Layout Setup

extension MovieSearchVC {
    private var views: [String: UIView] {
        let dict: [String: UIView] = ["table": tableView, "label": emptyTableLabel]
        return dict
    }
    
    private var allLayoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints += tableViewVConstraints
        constraints += tableViewHConstraints
        constraints += emptyTableLabelVConstraints
        constraints += emptyTableLabelHConstraints
        return constraints
    }
    
    private var tableViewVConstraints: [NSLayoutConstraint] {
        let VFLStr: String = "V:|[table]|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var tableViewHConstraints: [NSLayoutConstraint] {
        let VFLStr: String = "H:|[table]|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var emptyTableLabelHConstraints: [NSLayoutConstraint] {
        let VFLStr: String = "H:|[label]|"
        return NSLayoutConstraint.constraints(withVisualFormat: VFLStr, options: [], metrics: nil, views: views)
    }
    
    private var emptyTableLabelVConstraints: [NSLayoutConstraint] {
        let constraint = emptyTableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        return [constraint]
    }
    
    private var emptyTableLabelHeightConstraints: [NSLayoutConstraint] {
        let VFLStr: String = "V:[label(100)]"
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
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        updateTableViewContentInsetWithSearchBarInNavBar()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateTableViewContentInsetWithSearchBarBelowNavBar()
        presenter.handleSearchBarCancelButtonClicked()
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
            guard let loadingCell = dequeuedCell as? LoadingTableViewCell else {
                return dequeuedCell
            }
            
            let updatedLoadingCell = Self.getUpdatedLoadingTableViewCell(loadingCell: loadingCell)
            return updatedLoadingCell
        case .movieCell:
            guard let movieCell = dequeuedCell as? MovieListTableViewCell,
                  let movieCellViewData = presenter.getMovieCellViewData(indexPath: indexPath) else
            {
                return dequeuedCell
            }
            
            let updatedMovieCell = Self.getUpdatedMovieListTableViewCell(movieCell: movieCell,
                                                                         movieCellViewData: movieCellViewData)
            return updatedMovieCell
        }
    }
}

// MARK: - UITableViewDelegate Conformation

extension MovieSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.handleWillDisplayCellAtIndexPath(indexPath: indexPath)
    }
    
    // TODO: make the detail page with backdrop image, user rating, overview, and play trailer button and push to the
    // detail page upon tableView(_:didSelectRowAt:) being called.
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

// MARK: - Getters

extension MovieSearchVC {
    static func getUpdatedLoadingTableViewCell(loadingCell: LoadingTableViewCell) -> LoadingTableViewCell {
        loadingCell.loadingSpinner.startAnimating()
        return loadingCell
    }
    
    static func getUpdatedMovieListTableViewCell(movieCell: MovieListTableViewCell,
                                                 movieCellViewData: MovieCellViewData) -> MovieListTableViewCell
    {
        movieCell.posterImageView.updateImageByRemoteURL(imageURLStr: movieCellViewData.imageURLStr)
        movieCell.titleLabel.text = movieCellViewData.titleLabelStr
        movieCell.ratingRingView.percentLabel.text = movieCellViewData.percentLabelStr
        movieCell.ratingRingView.updateRingFill(percentage: movieCellViewData.ringFillPercent,
                                                ringHexColorStr: movieCellViewData.ringFillHexColorStr,
                                                animated: false)
        movieCell.dateLabel.text = movieCellViewData.dateLabelStr
        movieCell.overviewLabel.text = movieCellViewData.overviewLabelStr
        return movieCell
    }
}

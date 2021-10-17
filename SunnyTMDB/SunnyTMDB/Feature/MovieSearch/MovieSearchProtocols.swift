//
//  MovieSearchProtocols.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/16/21.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    func doInitialSetup()
}

protocol MovieSearchViewProtocol: AnyObject {
    func updateEmptyTableLabelText(text: String)
    func refreshTable()
    func doBatchOperationsInTable(indexPathsToDelete: [IndexPath], indexPathsToInsert: [IndexPath])
}

protocol MovieSearchPresenterProtocol: PresenterProtocol {
    var numberOfRowsInTable: Int { get }
    
    func attachView(view: MovieSearchViewProtocol)
    func handleSearchBarTextDidChange(searchText: String)
    func handleSearchBarCancelButtonClicked()
    func getCellTypeAtIndexPath(indexPath: IndexPath) -> MovieSearchTableCellType
    func getCellReuseIDAtIndexPath(indexPath: IndexPath) -> String
    func handleWillDisplayCellAtIndexPath(indexPath: IndexPath)
    func getMovieCellViewData(indexPath: IndexPath) -> MovieCellViewData?
}

protocol MovieSearchPresenterTestableProtocol: MovieSearchPresenterProtocol {
    var currentPage: Int { get set }
    var totalPagesCount: Int { get set }
    var cellDataList: [MovieSearchTableCellData] { get set }
    var movieSearchResultUpdateQueue: DispatchQueue { get }
    
    func resetSearchDataToDefaultState()
    func showEmptyResultsFromSearch()
    func doGetCallViaMovieSearchService(searchText: String, page: Int)
    func handleMovieSearchResultResponse(result: GetSearchMovieResponseDTO)
    func displayBrandNewSearchResult(result: GetSearchMovieResponseDTO)
    func displayNextPaginatedSearchResult(result: GetSearchMovieResponseDTO)
    func handleMovieSearchFailureResponse(statusCode: HTTPStatusCode?)
}

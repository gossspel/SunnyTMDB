//
//  MovieSearchPresenter.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/13/21.
//

import Foundation

class MovieSearchPresenter {
    weak private var view: MovieSearchViewProtocol?
    private let movieImageBaseURLStr: String
    private let movieSearchService: MovieSearchDataServiceProtocol
    private var searchTask: DispatchWorkItem?
    
    var cellDataList: [MovieSearchTableCellData] = []
    var currentPage: Int = 1
    var totalPagesCount: Int = 1
    private var currentSearchText: String = ""
    
    let movieSearchResultUpdateQueue: DispatchQueue = DispatchQueue(label: "movieSearchResultUpdateQueue",
                                                                    attributes: .concurrent)
    
    private static let defaultMovieImageBaseURLStr: String = "https://image.tmdb.org/t/p/w154"
    
    init(movieImageBaseURLStr: String = defaultMovieImageBaseURLStr,
         movieSearchService: MovieSearchDataServiceProtocol = MovieSearchDataService())
    {
        self.movieSearchService = movieSearchService
        self.movieImageBaseURLStr = movieImageBaseURLStr
    }
}

// MARK: - MovieSearchPresenterProtocol Conformation

extension MovieSearchPresenter: MovieSearchPresenterProtocol {
    var numberOfRowsInTable: Int {
        return cellDataList.count
    }
    
    func attachView(view: MovieSearchViewProtocol) {
        self.view = view
    }
    
    func doInitialSetup() {
        showEmptyResultsFromSearch()
    }
    
    func handleSearchBarTextDidChange(searchText: String) {
        // NOTE: do delayed search
        // LINK: https://stackoverflow.com/a/48666001
        
        searchTask?.cancel()
        
        let taskBlock: () -> Void = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.resetSearchDataToDefaultState()
            strongSelf.currentSearchText = searchText
            
            if searchText.isEmpty {
                strongSelf.showEmptyResultsFromSearch()
            } else {
                strongSelf.doGetCallViaMovieSearchService(searchText: searchText, page: strongSelf.currentPage)
            }
        }
        
        let newSearchTask = DispatchWorkItem(block: taskBlock)
        searchTask = newSearchTask
        
        let deadline: DispatchTime = DispatchTime.now() + 0.5
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: deadline, execute: newSearchTask)
    }
    
    func handleSearchBarCancelButtonClicked() {
        resetSearchDataToDefaultState()
        showEmptyResultsFromSearch()
    }
    
    func getCellTypeAtIndexPath(indexPath: IndexPath) -> MovieSearchTableCellType {
        guard indexPath.row < cellDataList.count else {
            return .movieCell
        }
        
        return cellDataList[indexPath.row].cellType
    }
    
    func getCellReuseIDAtIndexPath(indexPath: IndexPath) -> String {
        let cellType = getCellTypeAtIndexPath(indexPath: indexPath)
        return cellType.cellReuseID
    }
    
    func handleWillDisplayCellAtIndexPath(indexPath: IndexPath) {
        guard indexPath.row < cellDataList.count else {
            return
        }
        
        let cellType = getCellTypeAtIndexPath(indexPath: indexPath)
        let shouldFetchDataForNextPage: Bool = (cellType == .loadingCell) && (currentPage < totalPagesCount)
        
        guard shouldFetchDataForNextPage else {
            return
        }
        
        let deadline: DispatchTime = DispatchTime.now() + 0.5
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: deadline) {
            self.doGetCallViaMovieSearchService(searchText: self.currentSearchText, page: self.currentPage + 1)
        }
    }
    
    func getMovieCellViewData(indexPath: IndexPath) -> MovieCellViewData? {
        guard indexPath.row < cellDataList.count, let movieDTO = cellDataList[indexPath.row].movieDTO else {
            return nil
        }
        
        let imageURLStr = getMovieImageURLStr(imageFileURI: movieDTO.posterURI)
        let percentLabelStr = Self.getRatingPercentLabelText(ratingPercent: movieDTO.ratingPercent)
        let ringFillHexColorStr = Self.getHexColorStr(ratingPercent: movieDTO.ratingPercent)
        
        let cellViewData = MovieCellViewData(imageURLStr: imageURLStr,
                                             titleLabelStr: movieDTO.title,
                                             overviewLabelStr: movieDTO.overview,
                                             dateLabelStr: movieDTO.releaseDateStr,
                                             percentLabelStr: percentLabelStr,
                                             ringFillPercent: movieDTO.ratingPercent ?? 0,
                                             ringFillHexColorStr: ringFillHexColorStr)
        return cellViewData
    }
}

// MARK: - MovieSearchPresenterTestableProtocol Conformation

extension MovieSearchPresenter: MovieSearchPresenterTestableProtocol {
    func resetSearchDataToDefaultState() {
        cellDataList = []
        currentPage = 1
        totalPagesCount = 1
        currentSearchText = ""
    }
    
    func showEmptyResultsFromSearch() {
        DispatchQueue.main.async {
            self.view?.updateEmptyTableLabelText(text: self.emptyTableReason.displayStr)
            self.resetSearchDataToDefaultState()
            self.view?.refreshTable()
        }
    }
    
    func doGetCallViaMovieSearchService(searchText: String, page: Int) {
        let param = MovieSearchGetRequestParam(query: searchText, page: page)
        movieSearchService.sendGetRequest(param: param,
                                          successHandler: handleMovieSearchResultResponse,
                                          failureHandler: handleMovieSearchFailureResponse)
    }
    
    func handleMovieSearchResultResponse(result: MovieSearchResultDTO) {
        // NOTE: async barrier task only works on custom concurrent queues, but not global concurrent queues
        // LINK: https://stackoverflow.com/a/58238703
        movieSearchResultUpdateQueue.async(flags: .barrier) { [weak self] in
            guard let self = ConsoleUtility.validate(optional: self) else {
                return
            }
            
            if self.currentPage > 1 && (self.currentPage == result.currentPage) {
                ConsoleUtility.printConsoleMessage(messageType: .warning, message: "redundant page \(self.currentPage)")
                return
            }
            
            guard ConsoleUtility.validate(condition: self.currentPage <= result.currentPage) else {
                return
            }
            
            if result.movies.isEmpty {
                self.showEmptyResultsFromSearch()
                return
            }
            
            self.currentPage = result.currentPage
            self.totalPagesCount = result.totalPagesCount
            
            if self.currentPage == 1 {
                self.displayBrandNewSearchResult(result: result)
            } else {
                self.displayNextPaginatedSearchResult(result: result)
            }
        }
    }
    
    func displayBrandNewSearchResult(result: MovieSearchResultDTO) {
        let isCurrentPageTheLastPage: Bool = result.currentPage == result.totalPagesCount
        
        cellDataList = result.movies.map { MovieSearchTableCellData(cellType: .movieCell, movieDTO: $0) }
        
        if !isCurrentPageTheLastPage {
            cellDataList.append(MovieSearchTableCellData(cellType: .loadingCell, movieDTO: nil))
        }
        
        DispatchQueue.main.async {
            self.view?.refreshTable()
        }
    }
    
    func displayNextPaginatedSearchResult(result: MovieSearchResultDTO) {
        let isCurrentPageTheLastPage: Bool = result.currentPage == result.totalPagesCount

        // NOTE: remove any loading cell from cellDataList
        let indexPathsToDelete: [IndexPath] = Self.getLoadingCellsIndexPaths(cellDataList: cellDataList)
        cellDataList.removeAll { $0.cellType == .loadingCell }

        // NOTE: insert paginated movies cells in cellDataList
        let insertionCount: Int = !isCurrentPageTheLastPage ? (result.movies.count + 1) : result.movies.count
        let indexPathsToInsert: [IndexPath] = Self.getIndexPathsToInsert(cellDataList: cellDataList,
                                                                         insertionCount: insertionCount)
        cellDataList += result.movies.map { MovieSearchTableCellData(cellType: .movieCell, movieDTO: $0) }

        if !isCurrentPageTheLastPage {
            cellDataList.append(MovieSearchTableCellData(cellType: .loadingCell, movieDTO: nil))
        }

        // NOTE: update the table rows to reflect the datasource update.
        DispatchQueue.main.async {
            self.view?.doBatchOperationsInTable(indexPathsToDelete: indexPathsToDelete,
                                                indexPathsToInsert: indexPathsToInsert)
        }
    }
    
    func handleMovieSearchFailureResponse(statusCode: HTTPStatusCode?) {
        showEmptyResultsFromSearch()
    }
}

// MARK: - Utils

extension MovieSearchPresenter {
    var emptyTableReason: EmptyMovieSearchTableReason {
        if currentSearchText.isEmpty {
            return .noSearchQuery
        } else {
            return .noMoviesFromSearch
        }
    }
    
    static func getHexColorStr(ratingPercent: Int?) -> String? {
        guard let sureRatingPercent = ratingPercent else {
            return nil
        }
        
        let hexColorStr: String
        
        if sureRatingPercent >= 70 {
            hexColorStr = "#21d07a" // green
        } else if sureRatingPercent < 35 {
            hexColorStr = "#db2360" // red
        } else {
            hexColorStr = "#d2d531" // yellow
        }
        
        return hexColorStr
    }
    
    static func getRatingPercentLabelText(ratingPercent: Int?) -> String {
        let notAvailableStr: String = "N/A"
        
        guard let sureRatingPercent = ratingPercent else {
            return notAvailableStr
        }
        
        if sureRatingPercent == 0 {
            return notAvailableStr
        } else {
            return "\(sureRatingPercent)%"
        }
    }
    
    func getMovieImageURLStr(imageFileURI: String?) -> String? {
        guard let sureImageFileURI = imageFileURI else {
            return nil
        }
        
        return "\(movieImageBaseURLStr)\(sureImageFileURI)"
    }
    
    static func getLoadingCellsIndexPaths(cellDataList: [MovieSearchTableCellData]) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        
        for (index, cellData) in cellDataList.enumerated() {
            if cellData.cellType == .loadingCell {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
        }
        
        return indexPaths
    }
    
    static func getIndexPathsToInsert(cellDataList: [MovieSearchTableCellData],
                                      insertionCount: Int) -> [IndexPath]
    {
        guard insertionCount > 1 else {
            return []
        }
        
        let startingIndex: Int = cellDataList.count
        
        var indexPaths: [IndexPath] = []
        
        for n in 0..<insertionCount {
            indexPaths.append(IndexPath(row: startingIndex + n, section: 0))
        }
        
        return indexPaths
    }
}

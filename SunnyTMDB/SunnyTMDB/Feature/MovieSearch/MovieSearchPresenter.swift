//
//  MovieSearchPresenter.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/13/21.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    func doInitialSetup()
}

protocol MovieSearchPresenterProtocol: PresenterProtocol {
    var movieCellReuseID: String { get }
    var loadingCellReuseID: String { get }
    var numberOfRowsInTable: Int { get }
    
    func attachView(view: MovieSearchViewProtocol)
    func handleSearchBarTextDidChange(searchText: String)
    func getCellTypeAtIndexPath(indexPath: IndexPath) -> MovieSearchTableCellType
    func getCellReuseIDAtIndexPath(indexPath: IndexPath) -> String
    func handleWillDisplayCellAtIndexPath(indexPath: IndexPath)
    func getUpdatedMovieCell(cell: MovieListTableViewCellProtocol,
                             indexPath: IndexPath) -> MovieListTableViewCellProtocol?
}

enum MovieSearchTableCellType: String {
    case movieCell
    case loadingCell
}

struct MovieSearchTableCellData {
    let cellType: MovieSearchTableCellType
    let movieDTO: MovieDTO?
}

class MovieSearchPresenter {
    weak private var view: MovieSearchViewProtocol?
    let movieCellReuseID: String
    let loadingCellReuseID: String
    private let movieImageBaseURLStr: String
    private var searchTask: DispatchWorkItem?
    private var movieSearchService: MovieSearchDataServiceProtocol
    private var cellDataList: [MovieSearchTableCellData] = []
    
    private var currentPage: Int = 1
    private var totalPagesCount: Int = 1
    private var currentSearchText: String = ""
    
    private static let defaultMovieImageBaseURLStr: String = "https://image.tmdb.org/t/p/w154"
    private static let defaultMovieCellReuseID: String = "MovieListTableViewCell"
    private static let defaultLoadingCellReuseID: String = "LoadingTableViewCell"
    
    init(movieCellReuseID: String = defaultMovieCellReuseID,
         loadingCellReuseID: String = defaultLoadingCellReuseID,
         movieImageBaseURLStr: String = defaultMovieImageBaseURLStr,
         movieSearchService: MovieSearchDataServiceProtocol = MovieSearchDataService())
    {
        self.movieCellReuseID = movieCellReuseID
        self.loadingCellReuseID = loadingCellReuseID
        self.movieSearchService = movieSearchService
        self.movieImageBaseURLStr = movieImageBaseURLStr
    }
    
    private func refreshUI() {
        view?.refreshTable()
        view?.updateVisibilityOfTableBackgroundView(setIsHidden: !cellDataList.isEmpty)
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
        refreshUI()
    }
    
    func handleSearchBarTextDidChange(searchText: String) {
        // NOTE: do delayed search
        // LINK: https://stackoverflow.com/a/48666001
        
        searchTask?.cancel()
        
        let taskBlock: () -> Void = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.currentPage = 1
            strongSelf.totalPagesCount = 1
            strongSelf.currentSearchText = searchText
            strongSelf.doGetCallViaMovieSearchService(searchText: searchText, page: strongSelf.currentPage)
        }
        
        let newSearchTask = DispatchWorkItem(block: taskBlock)
        searchTask = newSearchTask
        
        let deadline: DispatchTime = DispatchTime.now() + 0.75
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: deadline, execute: newSearchTask)
    }
    
    func getCellTypeAtIndexPath(indexPath: IndexPath) -> MovieSearchTableCellType {
        guard indexPath.row < cellDataList.count else {
            return .movieCell
        }
        
        return cellDataList[indexPath.row].cellType
    }
    
    func getCellReuseIDAtIndexPath(indexPath: IndexPath) -> String {
        let cellType = getCellTypeAtIndexPath(indexPath: indexPath)
        switch cellType {
        case .loadingCell:
            return loadingCellReuseID
        case .movieCell:
            return movieCellReuseID
        }
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
        
        doGetCallViaMovieSearchService(searchText: currentSearchText, page: currentPage + 1)
    }
    
    func getUpdatedMovieCell(cell: MovieListTableViewCellProtocol,
                             indexPath: IndexPath) -> MovieListTableViewCellProtocol?
    {
        guard indexPath.row < cellDataList.count, let movieDTO = cellDataList[indexPath.row].movieDTO else {
            return nil
        }
        
        let imageURLStr = getMovieImageURLStr(imageFileURI: movieDTO.posterURI)
        cell.posterImageViewObject.updateImageByRemoteURL(imageURLStr: imageURLStr)
        cell.titleLabelObject.updateLabelText(text: movieDTO.title)
        cell.dateLabelObject.updateLabelText(text: movieDTO.releaseDateStr)
        let ratingPercentage: Int = Int(movieDTO.rating * 10)
        let hexColorStr = Self.getHexColorStr(ratingPercentage: ratingPercentage)
        cell.ratingRingViewObject.updateRingFill(percentage: ratingPercentage,
                                                 ringHexColorStr: hexColorStr,
                                                 animated: false)
        cell.ratingRingViewObject.percentLabelObject.updateLabelText(text: "\(ratingPercentage)%")
        return cell
    }
}

// MARK: - Service Related

extension MovieSearchPresenter {
    static func getMovieSearchGetRequestParam(searchText: String, page: Int) -> MovieSearchGetRequestParam {
        // Encode the query as indicated
        // LINK: https://developers.themoviedb.org/3/search/search-companies
        // LINK: https://www.advancedswift.com/a-guide-to-urls-in-swift/#url-encode-a-string
        let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return MovieSearchGetRequestParam(query: query, page: page)
    }
    
    private func doGetCallViaMovieSearchService(searchText: String, page: Int) {
        let param = Self.getMovieSearchGetRequestParam(searchText: searchText, page: page)
        movieSearchService.sendGetRequest(param: param,
                                          successHandler: handleMovieSearchResultResponse,
                                          failureHandler: handleMovieSearchFailureResponse)
    }
    
    private func handleMovieSearchResultResponse(result: MovieSearchResultDTO) {
        self.currentPage = result.currentPage
        self.totalPagesCount = result.totalPagesCount
        
        if currentPage == 1 {
            displayBrandNewSearchResult(result: result)
        } else {
            displayNextPaginatedSearchResult(result: result)
        }
    }
    
    private func displayBrandNewSearchResult(result: MovieSearchResultDTO) {
        let isCurrentPageTheLastPage: Bool = result.currentPage == result.totalPagesCount
        
        cellDataList = result.movies.map { MovieSearchTableCellData(cellType: .movieCell, movieDTO: $0) }
        
        if !isCurrentPageTheLastPage {
            cellDataList.append(MovieSearchTableCellData(cellType: .loadingCell, movieDTO: nil))
        }
        
        refreshUI()
    }
    
    private func displayNextPaginatedSearchResult(result: MovieSearchResultDTO) {
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
        view?.doBatchOperationsInTable(indexPathsToDelete: indexPathsToDelete,
                                       indexPathsToInsert: indexPathsToInsert)
    }
    
    private func handleMovieSearchFailureResponse(statusCode: HTTPStatusCode?) {
        cellDataList = []
        currentPage = 1
        totalPagesCount = 1
        currentSearchText = ""
        view?.emptyTableLabelObject.updateLabelText(text: "No movies found! Try searching again...")
        refreshUI()
    }
}

// MARK: - Utils

extension MovieSearchPresenter {
    static func getHexColorStr(ratingPercentage: Int) -> String {
        let hexColorStr: String
        
        if ratingPercentage >= 70 {
            hexColorStr = "#21d07a" // green
        } else if ratingPercentage < 35 {
            hexColorStr = "#db2360" // red
        } else {
            hexColorStr = "#d2d531" // yellow
        }
        
        return hexColorStr
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

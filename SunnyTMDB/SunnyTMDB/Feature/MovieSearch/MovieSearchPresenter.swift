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
    var numberOfRowsInTable: Int { get }
    
    func attachView(view: MovieSearchViewProtocol)
    func handleSearchBarTextDidChange(searchText: String)
}

class MovieSearchPresenter {
    weak private var view: MovieSearchViewProtocol?
    let movieCellReuseID: String
    private var searchTask: DispatchWorkItem?
    private var movieSearchService: MovieSearchDataServiceProtocol
    private var movieResults: [MovieDTO] = []
    
    init(movieCellReuseID: String = "MovieListTableViewCell",
         movieSearchService: MovieSearchDataServiceProtocol = MovieSearchDataService())
    {
        self.movieCellReuseID = movieCellReuseID
        self.movieSearchService = movieSearchService
    }
    
    private func refreshUI() {
        view?.refreshTable()
        view?.updateVisibilityOfTableBackgroundView(setIsHidden: !movieResults.isEmpty)
    }
}

// MARK: - MovieSearchPresenterProtocol Conformation

extension MovieSearchPresenter: MovieSearchPresenterProtocol {
    var numberOfRowsInTable: Int {
        return movieResults.count
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
            self?.doGetCallViaMovieSearchService(searchText: searchText)
        }
        
        let newSearchTask = DispatchWorkItem(block: taskBlock)
        searchTask = newSearchTask
        
        let deadline: DispatchTime = DispatchTime.now() + 0.75
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: deadline, execute: newSearchTask)
    }
}

// MARK: - Service Related

extension MovieSearchPresenter {
    static func getMovieSearchGetRequestParam(searchText: String) -> MovieSearchGetRequestParam {
        // Encode the query as indicated
        // LINK: https://developers.themoviedb.org/3/search/search-companies
        // LINK: https://www.advancedswift.com/a-guide-to-urls-in-swift/#url-encode-a-string
        let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return MovieSearchGetRequestParam(query: query)
    }
    
    private func doGetCallViaMovieSearchService(searchText: String) {
        let param = Self.getMovieSearchGetRequestParam(searchText: searchText)
        movieSearchService.sendGetRequest(param: param,
                                          successHandler: handleMovieSearchResultResponse,
                                          failureHandler: handleMovieSearchFailureResponse)
    }
    
    private func handleMovieSearchResultResponse(movieSearchResult: MovieSearchResultDTO) {
        if movieSearchResult.currentPage == 1 {
            movieResults = movieSearchResult.movies
            // TODO: refreshUI
        } else {
            movieResults += movieSearchResult.movies
            // TODO: call view to insert new rows base on updated datasource
            // TODO: decide how I want to handle pagination (inifinite scrolling/loading spinner cell at the end)
        }
    }
    
    private func handleMovieSearchFailureResponse(statusCode: HTTPStatusCode?) {
        movieResults = []
        view?.emptyTableLabelObject.updateLabelText(text: "No movies found! Try searching again...")
        refreshUI()
    }
}

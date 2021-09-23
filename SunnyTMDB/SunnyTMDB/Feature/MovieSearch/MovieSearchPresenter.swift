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
    var cellReuseID: String { get }
    
    func attachView(view: MovieSearchViewProtocol)
    func searchMovie(searchText: String)
}

class MovieSearchPresenter {
    weak private var view: MovieSearchViewProtocol?
    let cellReuseID: String
    private var searchTask: DispatchWorkItem?
    private var movieSearchService: MovieSearchDataServiceProtocol
    
    init(cellReuseID: String = "MovieListTableViewCell",
         movieSearchService: MovieSearchDataServiceProtocol = MovieSearchDataService())
    {
        self.cellReuseID = cellReuseID
        self.movieSearchService = movieSearchService
    }
}

// MARK: - MovieSearchPresenterProtocol Conformation

extension MovieSearchPresenter: MovieSearchPresenterProtocol {
    func attachView(view: MovieSearchViewProtocol) {
        self.view = view
    }
    
    func doInitialSetup() {
        // TODO: finish this
    }
    
    func searchMovie(searchText: String) {
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
        // TODO: finish this
    }
    
    private func handleMovieSearchFailureResponse(statusCode: HTTPStatusCode?) {
        // TODO: finish this
    }
}

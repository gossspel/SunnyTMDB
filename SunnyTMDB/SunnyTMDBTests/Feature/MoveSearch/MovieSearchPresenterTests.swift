//
//  MovieSearchPresenterTests.swift
//  SunnyTMDBTests
//
//  Created by Sunny Chan on 10/11/21.
//

import XCTest
@testable import SunnyTMDB

class MovieSearchPresenterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

// MARK: - MockMovieSearchView

class MockMovieSearchView: MovieSearchViewProtocol {
    var refreshTableCallCount: Int = 0
    var updateEmptyTableLabelTextCallCount: Int = 0
    var doBatchOperationsInTableCallCount: Int = 0
    
    func updateEmptyTableLabelText(text: String) {
        updateEmptyTableLabelTextCallCount += 1
    }
    
    func refreshTable() {
        refreshTableCallCount += 1
    }
    
    func doBatchOperationsInTable(indexPathsToDelete: [IndexPath], indexPathsToInsert: [IndexPath]) {
        doBatchOperationsInTableCallCount += 1
    }
}

// TODO: write tests for all non-private properties and methods in MovieSearchPresenter

// MARK: - handleMovieSearchResultResponse(result:)

extension MovieSearchPresenterTests {
    private enum HandleMovieSearchResultResponseScenario: String {
        // NOTE: scenarioA - presenter.currentPage == result.currentPage; result.totalPagesCount == result.currentPage;
        case scenarioA
        
        // NOTE: scenarioB - presenter.currentPage == result.currentPage; result.totalPagesCount != result.currentPage;
        case scenarioB
        
        // NOTE: scenarioC - presenter.currentPage < result.currentPage; result.totalPagesCount == result.currentPage;
        case scenarioC
        
        // NOTE: scenarioD - presenter.currentPage < result.currentPage; result.totalPagesCount != result.currentPage;
        case scenarioD
        
        // NOTE: scenarioE - presenter.currentPage > result.currentPage; result.totalPagesCount == result.currentPage;
        case scenarioE
        
        // NOTE: scenarioF - presenter.currentPage > result.currentPage; result.totalPagesCount != result.currentPage;
        case scenarioF
        
        var presenterCurrentPage: Int {
            return 1
        }
        
        var resultCurrentPage: Int {
            switch self {
            case .scenarioA, .scenarioB:
                return presenterCurrentPage
            case .scenarioC, .scenarioD:
                return presenterCurrentPage + 1
            case .scenarioE, .scenarioF:
                return presenterCurrentPage - 1
            }
        }
        
        var resultTotalPagesCount: Int {
            switch self {
            case .scenarioA, .scenarioC, .scenarioE:
                return resultCurrentPage
            case .scenarioB, .scenarioD, .scenarioF:
                return resultCurrentPage + 1
            }
        }
    }
    
    static func getMockResult(numberOfMovies: Int,
                              currentPage: Int,
                              totalPagesCount: Int) -> GetSearchMovieResponseDTO
    {
        var movies: [MovieDTO] = []
        for _ in 0..<numberOfMovies {
            movies.append(MovieDTO(title: "", overview: "", releaseDateStr: "", posterURI: "", rating: 0, genreIDs: []))
        }
        let result = GetSearchMovieResponseDTO(currentPage: currentPage,
                                               totalPagesCount: totalPagesCount,
                                               movies: movies)
        return result
    }
    
    func testHandleMovieSearchResultResponse_withScenarioA_shouldUpdateDataAndCallRefreshTable() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioA
        XCTAssertEqual(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        presenter.handleMovieSearchResultResponse(result: mockResult)
        presenter.movieSearchResultUpdateQueue.sync { [weak presenter] in
            guard let presenter = presenter else {
                XCTFail("presenter is nil")
                return
            }
            
            let loadingCellDataList = presenter.cellDataList.filter { $0.cellType == .loadingCell }
            XCTAssert(loadingCellDataList.isEmpty)
            XCTAssertEqual(presenter.cellDataList.count, mockResult.movies.count)
            XCTAssertEqual(presenter.currentPage, mockResult.currentPage)
            XCTAssertEqual(presenter.totalPagesCount, mockResult.totalPagesCount)
            
            DispatchQueue.main.async {
                XCTAssertEqual(view.refreshTableCallCount, 1)
                XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
                XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withScenarioB_shouldUpdateDataAndCallRefreshTable() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioB
        XCTAssertEqual(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertNotEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        presenter.handleMovieSearchResultResponse(result: mockResult)
        presenter.movieSearchResultUpdateQueue.sync { [weak presenter] in
            guard let presenter = presenter else {
                XCTFail("presenter is nil")
                return
            }
            
            let loadingCellDataList = presenter.cellDataList.filter { $0.cellType == .loadingCell }
            XCTAssert(!loadingCellDataList.isEmpty)
            XCTAssertEqual(presenter.cellDataList.count, mockResult.movies.count + loadingCellDataList.count)
            XCTAssertEqual(presenter.currentPage, mockResult.currentPage)
            XCTAssertEqual(presenter.totalPagesCount, mockResult.totalPagesCount)
            
            DispatchQueue.main.async {
                XCTAssertEqual(view.refreshTableCallCount, 1)
                XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
                XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withScenarioC_shouldUpdateDataAndCallDoBatchOperationsInTable() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioC
        XCTAssertLessThan(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        presenter.handleMovieSearchResultResponse(result: mockResult)
        presenter.movieSearchResultUpdateQueue.sync { [weak presenter] in
            guard let presenter = presenter else {
                XCTFail("presenter is nil")
                return
            }
            
            let loadingCellDataList = presenter.cellDataList.filter { $0.cellType == .loadingCell }
            XCTAssert(loadingCellDataList.isEmpty)
            XCTAssertEqual(presenter.cellDataList.count, mockResult.movies.count)
            XCTAssertEqual(presenter.currentPage, mockResult.currentPage)
            XCTAssertEqual(presenter.totalPagesCount, mockResult.totalPagesCount)
            
            DispatchQueue.main.async {
                XCTAssertEqual(view.doBatchOperationsInTableCallCount, 1)
                XCTAssertEqual(view.refreshTableCallCount, 0)
                XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withScenarioD_shouldUpdateDataAndCallDoBatchOperationsInTable() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioD
        XCTAssertLessThan(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertNotEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        presenter.handleMovieSearchResultResponse(result: mockResult)
        presenter.movieSearchResultUpdateQueue.sync { [weak presenter] in
            guard let presenter = presenter else {
                XCTFail("presenter is nil")
                return
            }
            
            let loadingCellDataList = presenter.cellDataList.filter { $0.cellType == .loadingCell }
            XCTAssert(!loadingCellDataList.isEmpty)
            XCTAssertEqual(presenter.cellDataList.count, mockResult.movies.count + loadingCellDataList.count)
            XCTAssertEqual(presenter.currentPage, mockResult.currentPage)
            XCTAssertEqual(presenter.totalPagesCount, mockResult.totalPagesCount)
            
            DispatchQueue.main.async {
                XCTAssertEqual(view.doBatchOperationsInTableCallCount, 1)
                XCTAssertEqual(view.refreshTableCallCount, 0)
                XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withScenarioE_shouldDoNothing() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioE
        XCTAssertGreaterThan(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        presenter.handleMovieSearchResultResponse(result: mockResult)
        presenter.movieSearchResultUpdateQueue.sync { [weak presenter] in
            guard let presenter = presenter else {
                XCTFail("presenter is nil")
                return
            }
            
            XCTAssertEqual(presenter.currentPage, 1)
            XCTAssertEqual(presenter.totalPagesCount, 1)
            XCTAssert(presenter.cellDataList.isEmpty)
            
            DispatchQueue.main.async {
                XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
                XCTAssertEqual(view.refreshTableCallCount, 0)
                XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withScenarioF_shouldDoNothing() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioF
        XCTAssertGreaterThan(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertNotEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        presenter.handleMovieSearchResultResponse(result: mockResult)
        presenter.movieSearchResultUpdateQueue.sync { [weak presenter] in
            guard let presenter = presenter else {
                XCTFail("presenter is nil")
                return
            }
            
            XCTAssertEqual(presenter.currentPage, 1)
            XCTAssertEqual(presenter.totalPagesCount, 1)
            XCTAssert(presenter.cellDataList.isEmpty)
            
            DispatchQueue.main.async {
                XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
                XCTAssertEqual(view.refreshTableCallCount, 0)
                XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withConcurrentDuplicatedResults_shouldUpdateDataFromOneResultOnly() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioC
        XCTAssertLessThan(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        let concurrentDuplicatedResultsCount: Int = 10
        var handledResultCount: Int = 0
        let concurrentHandledResultCountQueue = DispatchQueue(label: "concurrentHandledResultCountQueue",
                                                              attributes: .concurrent)
        
        for _ in 0..<concurrentDuplicatedResultsCount {
            concurrentHandledResultCountQueue.async { [weak concurrentHandledResultCountQueue, weak presenter] in
                guard let concurrentHandledResultCountQueue = concurrentHandledResultCountQueue,
                      let presenter = presenter else
                {
                    XCTFail("has a nil captured object")
                    return
                }
                
                // NOTE: concurrently execute handleMovieSearchResultResponse(result:) multiple times
                presenter.handleMovieSearchResultResponse(result: mockResult)
                
                concurrentHandledResultCountQueue.async(flags: .barrier) {
                    handledResultCount += 1
                    
                    guard handledResultCount == concurrentDuplicatedResultsCount else {
                        return
                    }
                    
                    // NOTE: after the last handleMovieSearchResultResponse(result:) started to execute, check to make
                    // sure the cellDataList is updated with only one result.
                    presenter.movieSearchResultUpdateQueue.sync {
                        let loadingCellDataList = presenter.cellDataList.filter { $0.cellType == .loadingCell }
                        XCTAssert(loadingCellDataList.isEmpty)
                        XCTAssertEqual(presenter.cellDataList.count, mockResult.movies.count)
                        XCTAssertEqual(presenter.currentPage, mockResult.currentPage)
                        XCTAssertEqual(presenter.totalPagesCount, mockResult.totalPagesCount)
                        
                        DispatchQueue.main.async {
                            XCTAssertEqual(view.doBatchOperationsInTableCallCount, 1)
                            XCTAssertEqual(view.refreshTableCallCount, 0)
                            XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testHandleMovieSearchResultResponse_withSerialDuplicatedResults_shouldUpdateDataFromOneResultOnly() {
        let expectation = XCTestExpectation()
        
        let scenario: HandleMovieSearchResultResponseScenario = .scenarioC
        XCTAssertLessThan(scenario.presenterCurrentPage, scenario.resultCurrentPage)
        XCTAssertEqual(scenario.resultCurrentPage, scenario.resultTotalPagesCount)
        
        let presenter: MovieSearchPresenterTestableProtocol = MovieSearchPresenter()
        presenter.currentPage = scenario.presenterCurrentPage
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertEqual(presenter.totalPagesCount, 1)
        XCTAssert(presenter.cellDataList.isEmpty)
        
        let view = MockMovieSearchView()
        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 0)
        XCTAssertEqual(view.refreshTableCallCount, 0)
        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
        
        presenter.attachView(view: view)
        
        let numberOfMovies: Int = 10
        let mockResult: GetSearchMovieResponseDTO = Self.getMockResult(numberOfMovies: numberOfMovies,
                                                                       currentPage: scenario.resultCurrentPage,
                                                                       totalPagesCount: scenario.resultTotalPagesCount)
        
        let concurrentDuplicatedResultsCount: Int = 10
        let serialHandledResultCountQueue = DispatchQueue(label: "serialHandledResultCountQueue")
        
        for index in 0..<concurrentDuplicatedResultsCount {
            serialHandledResultCountQueue.async { [weak presenter] in
                guard let presenter = presenter else {
                    XCTFail("presenter is nil")
                    return
                }
                
                // NOTE: serially execute handleMovieSearchResultResponse(result:) multiple times
                presenter.handleMovieSearchResultResponse(result: mockResult)
                
                guard index == concurrentDuplicatedResultsCount - 1 else {
                    return
                }
                
                // NOTE: after the last handleMovieSearchResultResponse(result:) started to execute, check to make
                // sure the cellDataList is updated with only one of the resultDTOs.
                presenter.movieSearchResultUpdateQueue.sync {
                    let loadingCellDataList = presenter.cellDataList.filter { $0.cellType == .loadingCell }
                    XCTAssert(loadingCellDataList.isEmpty)
                    XCTAssertEqual(presenter.cellDataList.count, mockResult.movies.count)
                    XCTAssertEqual(presenter.currentPage, mockResult.currentPage)
                    XCTAssertEqual(presenter.totalPagesCount, mockResult.totalPagesCount)
                    
                    DispatchQueue.main.async {
                        XCTAssertEqual(view.doBatchOperationsInTableCallCount, 1)
                        XCTAssertEqual(view.refreshTableCallCount, 0)
                        XCTAssertEqual(view.updateEmptyTableLabelTextCallCount, 0)
                        expectation.fulfill()
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

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
    func attachView(view: MovieSearchViewProtocol)
}

class MovieSearchPresenter {
    
}

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

// MARK: - View Controller Life Cycle

extension MovieSearchVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - View Setup

extension MovieSearchVC {
    private func loadTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = cellOuterPadding * 2 + cellPosterHeight
        
        // NOTE: Eliminate extra separators below UITableView
        // LINK: https://stackoverflow.com/a/5377569
        tableView.tableFooterView = UIView(frame: .zero)
        
        // TODO: finish this
    }
}

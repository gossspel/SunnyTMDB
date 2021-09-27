//
//  LoadingTableViewCell.swift
//  SunnyTMDB
//
//  Created by Sunny Chan on 9/27/21.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    private var overallHeight: CGFloat = 182

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Setup

extension LoadingTableViewCell {
    private func loadSubviews() {
        // TODO: finish this
    }
}

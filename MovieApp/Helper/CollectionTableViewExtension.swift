//
//  CollectionTableViewExtension.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 05/03/25.
//

import UIKit



extension UITableView {
    func setEmptyMessage(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        label.text = message
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        label.text = message
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        
        self.backgroundView = label
    }
    
    func restore() {
        self.backgroundView = nil
    }
}


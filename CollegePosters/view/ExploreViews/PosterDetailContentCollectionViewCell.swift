//
//  PosterDetailContentCollectionViewCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDetailContentCollectionViewCell: UICollectionViewCell {
    
    var poster: Poster? {
        didSet {
            if let description = poster?.posterDescription {
                contentLabel.text = description
            }
        }
    }
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        buildCell()
    }
    
    func buildCell() {
        addSubview(contentLabel)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        
        addSubview(separator)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ExploreMenuBar.swift
//  CollegePosters
//
//  Created by 姜曦 on 04/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ExploreMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var exploreController: ExploreCollectionViewController?
    let cellId = "menuBarCell"
    let navImageNames = ["trend", "follow", "category", "category"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": collectionView]))
        backgroundColor = UIColor.white
        
        let selectedMenuBarCell = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedMenuBarCell, animated: false, scrollPosition: [])
        
        setupHorizontalBar()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    var hbLeftAnchor: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let hb = UIView()
        hb.backgroundColor = UIColor.black
        hb.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hb)
        
        hbLeftAnchor = hb.leftAnchor.constraint(equalTo: self.leftAnchor)
        hbLeftAnchor?.isActive = true
        hb.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        hb.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        hb.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        exploreController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCell
        
        cell.imageView.image = UIImage(named: navImageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.imageView.contentMode = UIViewContentMode.center
        cell.tintColor = UIColor.gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuBarCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "trend")?.withRenderingMode(.alwaysTemplate))
        iv.contentMode = UIViewContentMode.center
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.black : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.black : UIColor.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

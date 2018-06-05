//
//  ExploreBaseCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 05/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ExploreBaseCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var posters: [Poster] = [Poster]()
    
    lazy var cvt: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.brown
        addSubview(cvt)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        
        cvt.register(ExploreCell.self, forCellWithReuseIdentifier: cellId)
        cvt.backgroundColor = UIColor.white
        
        //testing
        
        //test images
        testImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
        
        // Configure the cell
        // Configure like button
        cell.likebtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        
        // Render poster on cell
        cell.poster = posters[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        let height = (width - 20) / 3 * 4
        return CGSize(width: width, height: height + 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func likeBtnTapped(sender: UIButton!) -> Void {
        print("like btn tapped")
        let liked = UIImage(named: "heartfilled33")
        let unliked = UIImage(named: "heart33")
        
        if sender.imageView!.image!.isEqual(liked) {
            sender.setImage(unliked , for: .normal)
        } else {
            sender.setImage(liked, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func testImages() {
        
    }
}

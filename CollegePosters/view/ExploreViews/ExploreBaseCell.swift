//
//  ExploreBaseCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 05/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ExploreBaseCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var posters: [Poster] = [Poster]()
    let posterGetter = HttpApiService.sharedHttpApiService
    var alreadyLoaded: Int = 0
    var isLoading = false
    var section: String?
    
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
        setSection()
        if self.section == "getExplorePosters" || self.section == "getTrendPosters" {
            testImages()
        } else {
            fetchPosters(from: 0)
        }
    }
    
    func setSection() {
        return
    }
    
    func fetchPosters(from: Int) {
        if from == 0 {
            if posters.count != 0 {
                posters = [Poster]()
            }
            self.alreadyLoaded = 0
        }
        
        posterGetter.fetchPosters(with: section!, from: from) { (posters) in
            self.posters.append(contentsOf: posters)
            self.alreadyLoaded += posters.count
            DispatchQueue.main.async {
                self.cvt.reloadData()
                self.isLoading = false
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentOffSetY = scrollView.contentOffset.y
        print(contentOffSetY)
        print("height: \(height)")
       
        if contentOffSetY < -100 && !isLoading{
            isLoading = true
            fetchPosters(from: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == alreadyLoaded - 1{
            isLoading = true
            fetchPosters(from: alreadyLoaded)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
        
        // Configure the cell
        if !isLoading {
            // Configure like button
            cell.likebtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        
            cell.posterImage.image = nil
            
            // Render poster on cell
            cell.poster = posters[indexPath.item]
        }
        
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
        let unliked = UIImage(named: "heart33")
        
        
        guard let sender = sender as? likeButton else {
            print("button type casting failed")
            return
        }
        
        if !sender.likeBtnPressed {
            sender.likeBtnPressed = true
            let like = sender.imageView!.image!.isEqual(unliked)
            like ? print("is liking") : print("is unliking")
            HttpApiService.sharedHttpApiService.likeBtnPressed(with: sender.posterId!, btn: sender, like: like)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func testImages() {
        
    }
}

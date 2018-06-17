//
//  ExploreBaseCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 05/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

var originalPoster: Poster?

class ExploreBaseCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var posters: [Poster] = [Poster]()
    var postersId: [Int] = [Int]()
    let posterGetter = HttpApiService.sharedHttpApiService
    var alreadyLoaded: Int = 0
    var isLoading = false
    var section: String?
    let posterDetail = PosterDetailLauncher()
    var originC: CGPoint?
    var rc = UIRefreshControl()
    
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
        cvt.refreshControl = rc
        rc.tintColor = .black
        rc.addTarget(self, action: #selector(refreshAllPost), for: .valueChanged)
        
        //test images
        setSection()
        fetchPosters(from: 0)
    }
    
    @objc func refreshAllPost() {
        if !isLoading{
            isLoading = true
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
                postersId = [Int]()
            }
            self.alreadyLoaded = 0
        }
        
        posterGetter.fetchPosters(with: section!, from: from, keyword: nil) { (posters) in
            //self.posters.append(contentsOf: posters)
            self.selectForRender(posters: posters)
            self.alreadyLoaded += posters.count
            DispatchQueue.main.async {
                self.isLoading = false
                self.cvt.reloadData()
                self.rc.endRefreshing()
            }
        }
    }
    
    
    
    func selectForRender(posters: [Poster]) {
        for poster in posters {
            let id = poster.postId!
            if !postersId.contains(id) {
                self.posters.append(poster)
                self.postersId.append(id)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == alreadyLoaded - 1 && !isLoading{
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

            cell.likebtn.imageView?.image = UIImage(named: "heart33")
            
            // Render poster on cell
            cell.poster = posters[indexPath.item]
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newL = PosterDetailLauncher()
        newL.exitGesture.edges = .left
        newL.exitGesture.addTarget(self, action: #selector(handleSwipe(_:)))
        newL.showPosterDetail(posters[indexPath.item])
        originC = newL.mainV?.center
        originalPoster = posters[indexPath.item]
        print("set original poster")
        print(originalPoster)
    }
    
    @objc func handleSwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
        BtnActions().handleSwipe(sender, originC: originC!, frame: frame)
    }
    
    @IBAction func likeBtnTapped(sender: UIButton!) -> Void {
        BtnActions().likeBtnTapped(sender: sender)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        let height = (width - 20) / 3 * 4
        return CGSize(width: width, height: height + 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func testImages() {
        
    }
}

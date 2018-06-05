//
//  ExploreTrendCollectionViewController.swift
//  College Posters
//
//  Created by 姜曦 on 31/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ExploreCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var postersSrcUrl: String?
    let trendId = "trendCell"
    let followId = "followCell"
    let indexToIdMap = [0: "trendCell", 1: "followCell"]
    
    lazy var menuBar: ExploreMenuBar = {
        let mb = ExploreMenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.exploreController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(TrendCell.self, forCellWithReuseIdentifier: trendId)
        self.collectionView!.register(FollowCell.self, forCellWithReuseIdentifier: followId)

        // Do any additional setup after loading the view.
        
        setupCollectionView()
        
        collectionView?.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        setupMenuBar()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.hbLeftAnchor?.constant = scrollView.contentOffset.x / 2
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        collectionView?.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    private func setupMenuBar() {
        
        //navigationController?.hidesBarsOnSwipe = true

        
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(whiteView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": whiteView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": whiteView]))
        
        view.addSubview(menuBar)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": menuBar]))
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexToIdMap[indexPath.item]!, for: indexPath)
            
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

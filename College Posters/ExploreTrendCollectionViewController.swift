//
//  ExploreTrendCollectionViewController.swift
//  College Posters
//
//  Created by 姜曦 on 31/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

private let reuseIdentifier = "trendCell"

class ExploreTrendCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posters: [Poster] = [Poster]()
    var postersSrcUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ExploreTrendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let test1Poster = Poster()
        test1Poster.posterImageName = "heart33"
        test1Poster.posterTitle = "Some stupid title"
        let test2Poster = Poster()
        test2Poster.posterImageName = "test2"
        test2Poster.posterTitle = "Some other stupid title"
        
        posters = [test1Poster, test2Poster]

        // Do any additional setup after loading the view.
    }
    
    func addNewPosters(_ posters: Poster...) {
        for poster in posters {
            self.posters.append(poster)
        }
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
        return posters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExploreTrendCell
    
        // Configure the cell
        // Configure like button
        cell.likebtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        
        // Render poster on cell
        cell.poster = posters[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
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

}

class ExploreTrendCell : UICollectionViewCell {
    
    var poster: Poster? {
        didSet {
            cellLabel.text = poster?.posterTitle
            if let imageName = poster?.posterImageName {
                posterImage.image = UIImage(named: imageName)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.image = UIImage(named: "test2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "some example text plus djfklajsdklfjajlsnd jklbafjal nsdjknfajln vjlkbajdn fjkabsdjo fnajksdnf jlansdfjk bajosdnf kasdgj a;dsnga a"
        return label
    }()
    
    

    var likebtn : UIButton = {
        let likeImage = UIImage(named: "heart33")
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0,y: 0,width: 33,height: 33)
        btn.setImage(likeImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    
    func buildCellView() {
        backgroundColor = UIColor.white
        addSubview(posterImage)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": posterImage]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-60-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": posterImage]))
        
        addSubview(separator)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))

        addSubview(cellLabel)
        addConstraint(NSLayoutConstraint(item: cellLabel, attribute: .top, relatedBy: .equal, toItem: posterImage, attribute: .bottom, multiplier: 1, constant: 8))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cellLabel]))
        addConstraint(NSLayoutConstraint(item: cellLabel, attribute: .leading, relatedBy: .equal, toItem: posterImage, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: cellLabel, attribute: .trailing, relatedBy: .equal, toItem: posterImage, attribute: .trailing, multiplier: 1, constant: -50))
        
        addSubview(likebtn)
        addConstraint(NSLayoutConstraint(item: likebtn, attribute: .top, relatedBy: .equal, toItem: posterImage, attribute: .bottom, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: likebtn, attribute: .trailing, relatedBy: .equal, toItem: posterImage, attribute: .trailing, multiplier: 1, constant: -7))
        print("built cell")

    }
    
}

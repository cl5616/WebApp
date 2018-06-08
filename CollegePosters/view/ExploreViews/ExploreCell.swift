//
//  ExploreTrendCollectionViewCell.swift
//  College Posters
//
//  Created by 姜曦 on 31/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ExploreCell : UICollectionViewCell {

    var poster: Poster? {
        didSet {
            cellLabel.text = poster?.posterTitle
            if let imageName = poster?.posterImageName {
                setImage(withName: imageName)
            }
            likebtn.posterId = poster?.postId
        }
    }
    
    func setImage(withName: String) {
        
        if withName == "fire64" {
            return
        }

        posterImage.url = withName
        
        let picFolderUrl = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/pic/"
        let combinedUrl = picFolderUrl + withName
        let url = URL(string: combinedUrl)
        
        if let imageFromCache = imageCache.object(forKey: withName as NSString) {
            posterImage.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: withName as NSString)
                if self.posterImage.url == withName {
                    self.posterImage.image = imageToCache
                }
            }
        }.resume()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildCellView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    let posterImage: CellImageView = {
        let imageView = CellImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true

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
        return label
    }()



    var likebtn : likeButton = {
        let likeImage = UIImage(named: "heart33")
        let btn = likeButton(type: .custom)
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
        addConstraint(NSLayoutConstraint(item: cellLabel, attribute: .leading, relatedBy: .equal, toItem: posterImage, attribute: .leading, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: cellLabel, attribute: .trailing, relatedBy: .equal, toItem: posterImage, attribute: .trailing, multiplier: 1, constant: -50))

        addSubview(likebtn)
        addConstraint(NSLayoutConstraint(item: likebtn, attribute: .top, relatedBy: .equal, toItem: posterImage, attribute: .bottom, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: likebtn, attribute: .trailing, relatedBy: .equal, toItem: posterImage, attribute: .trailing, multiplier: 1, constant: -7))
    }

}

class likeButton: UIButton {
    var posterId: Int?
    var likeBtnPressed: Bool = false
}

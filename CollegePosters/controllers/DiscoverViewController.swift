//
//  DiscoverViewController.swift
//  College Posters
//
//  Created by 姜曦 on 30/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var vt: UIView = {
        let v = UIView(frame: CGRect(x: 50, y: 200, width: 100, height: 100))
        v.backgroundColor = .blue
        //v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(vt)
        self.view.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleG(_:)))
        vt.addGestureRecognizer(tap)
        vt.isUserInteractionEnabled = true
    }
    
    @objc func handleG(_ sender: UITapGestureRecognizer) {
        print ("hello gesture")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

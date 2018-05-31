//
//  PostViewController.swift
//  College Posters
//
//  Created by 姜曦 on 30/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    var picker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectButton.isHidden = true
            self.nextButton.isEnabled = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Invalid Photo Source", message: "No access to Camera.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        let postDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "postDetailVC")
        self.navigationController!.pushViewController(postDetailViewController!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        picker.delegate = self
        self.navigationItem.rightBarButtonItem = nextButton
    }

}

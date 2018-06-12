//
//  StringExtension.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 15)], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 15)], context: nil)
        
        return ceil(boundingBox.width)
    }
}

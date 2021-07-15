//
//  MeMeShareModal.swift
//  MeMeShare
//
//  Created by Kavya Joshi on 7/9/21.
//

import Foundation
import UIKit

struct MeMeShareModal
{
    var  topText : String
    var bottomText : String
    var originalImage : UIImage
    var memeImage : UIImage
    
    
    
}


struct Attributes
{
   static let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSAttributedString.Key.strokeWidth: -5.00
    ]
}

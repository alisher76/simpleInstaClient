//
//  PhotoCollectionViewCell.swift
//  finalTestInstagram
//
//  Created by Alisher Abdukarimov on 5/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: [String:Any]! {
        didSet {
            InstagramData.imageForPhoto(photoDisctionary: photo, size: "thumbnail") { (image) in
                self.imageView.image = image
            }
        }
    }
}


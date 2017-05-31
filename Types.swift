//
//  Types.swift
//  finalTestInstagram
//
//  Created by Alisher Abdukarimov on 5/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import SAMCache

struct InstagramUser {
    
    var token: String = ""
    var uid: String = ""
    var bio: String = ""
    var followed_by: String = ""
    var follows: String = ""
    var media: String = ""
    var username: String = ""
    var image: String = ""

}


class InstagramData {
    
    static func imageForPhoto(photoDisctionary: [String:Any], size: String, completion: @escaping (_ image: UIImage) -> Void) {
        
        
        let imageSize = photoDisctionary[size] as! [String:Any]
        let urlString = imageSize["url"] as! String
        let key = "\(urlString)-\(size)"
        
        if let image = SAMCache.shared().image(forKey: key) {
            completion(image)
        }else{
            
            let url = URL(string: urlString)!
            let session = URLSession.shared
            let request = URLRequest(url: url)
            let task = session.downloadTask(with: request) { (localData, responce, error) -> Void in
                if error == nil {
                    do {
                        let data = try Data(contentsOf: localData!)
                        let image = UIImage(data: data)
                        SAMCache.shared().setImage(image, forKey: key)
                        DispatchQueue.main.async(execute: {
                            completion(image!)
                        })

                    }catch{
                        print(error)
                }
            }
          }
            task.resume()
        }
    }
}

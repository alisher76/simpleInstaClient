//
//  ExploreCollectionViewController.swift
//  finalTestInstagram
//
//  Created by Alisher Abdukarimov on 5/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class ExploreCollectionViewController: UICollectionViewController {
    
    private var accessToken: String!
    
    var photoDictionaries = [[String:Any]]()
    struct Stroryboard {
        static let exploreCell = "Explorecell"
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.white
        
        authInstagram()
    
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoDictionaries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Stroryboard.exploreCell, for: indexPath) as! PhotoCollectionViewCell
        
       cell.photo = photoDictionaries[indexPath.row]
        
    
        return cell
    }
    
    func authInstagram() {
        
        
        //SaveChanges
        let userDefaults = UserDefaults.standard
        
        if let token = userDefaults.object(forKey: "accessToken") as? String {
            self.accessToken = token
            print("Already logged in\(accessToken)")
           fetchPhotos()
        } else {
        
            SimpleAuth.authorize("instagram", options: ["scope": ["public_content"]]) { (oResult: Any?, error: Error?) -> Void in
                // Getting data and also accessing to Token
                if let result = oResult as? [String:Any] {
                    let credentials = result["credentials"] as! [String:Any]
                    let accessToken = credentials["token"] as! String
                    self.accessToken = accessToken
                    print(accessToken)
                    //If a user has not logged in yet then when they do we save a copy
                    userDefaults.set(self.accessToken, forKey: "accessToken")
                    userDefaults.synchronize()
                }
            }
        }
    }
    
    func urlWithSearchText(searchText: String) -> URL {
        
        let correctedSearchText = searchText.replacingOccurrences(of: " ", with: "")
        let urlString = "https://api.instagram.com/v1/tags/\(correctedSearchText)/media/recent?access_token=\(accessToken!)"
        let url = URL(string: urlString)!
        return url
    
    }
    
    func fetchPhotos() {
        let session = URLSession.shared
        let url: URL
        
        if self.searchBar.text?.isEmpty == true {
            url = urlWithSearchText(searchText: "kennesaw")
            
        }else{
            url = self.urlWithSearchText(searchText: self.searchBar.text!)
        }
        
        let request = URLRequest(url: url)
    
        let task = session.dataTask(with: request) { (oData, oResponce, oError) in
            if oError != nil {
                print("error")
                return
            }else{
                if let data = oData {
                    do {
                        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                        let allData = dictionary["data"] as! [[String:Any]]
                        for i in allData {
                            self.photoDictionaries.append(i["images"] as! [String : Any])
                            print(self.photoDictionaries)
                        }
                        
                        
                    }catch{
                    print(error)
                    }
                }
            }
            OperationQueue.main.addOperation {
                self.collectionView?.reloadData()
            }
        }
        task.resume()
    }

}

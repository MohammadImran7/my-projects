//
//  ViewController.swift
//  LocalityDetails
//
//  Created by fkhader on 6/23/20.
//  Copyright © 2020 fkhader. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private let baseURL = "https://extendsclass.com/api/json-storage/bin/eadeffc"
    private let reuseIdentifier = "placeDescCellView"
    
    var dataTask: URLSessionDataTask?
    var searchResults: [Country] = []
    var countryDetails: [CountryDetails] = []
    
    @IBOutlet weak var placesCollectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCountryDetails()
    }
    
    func updateUI() {
        self.collectionView.reloadData()
        
        if (searchResults.count > 0){
            let mainTitle = searchResults[0]
            self.navigationBar.topItem?.title = mainTitle.title
        }
        else{
            self.navigationBar.topItem?.title = "Error Loading"
        }
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.countryDetails.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.titleLabel.text = self.countryDetails[indexPath.item].title
        cell.descriptionLabel.text = self.countryDetails[indexPath.item].description
        
        let placePhoto = photo(for: indexPath)
        cell.imageHerfView.image = placePhoto!.thumbnail

        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        
        cell.imageHerfView.image = nil
       
        DispatchQueue.global().async {
            
            let urlString = self.countryDetails[indexPath.item].imageHref
            
            if urlString == ""{
            }
            else{
                let data = try? Data(contentsOf: URL(string: "\(urlString ?? " ")")!)
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                        cell.imageHerfView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    

    func loadCountryDetails() {
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        let url = URL(string: baseURL)
        // from the session you created, you initialize a URLSessionDataTask to handle the HTTP GET request.
        // the constructor of URLSessionDataTask takes in the URL that you constructed along with a completion handler to be called when the data task completed
        dataTask = URLSession.shared.dataTask(with: url!) {
            data, response, error in
            // invoke the UI update in the main thread and hide the activity indicator to show that the task is completed
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            // if HTTP request is successful you call updateSearchResults(_:) which parses the response NSData into Tracks and updates the table view
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateResuls(data)
                }
            }
        }
        // all tasks start in a suspended state by default, calling resume() starts the data task
        dataTask?.resume()
    }
    
    func updateResuls(_ data: Data!) {
        searchResults.removeAll()
        
        do {
            if
                let data = data,
                let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                // Get the results array
                if let array = response as? Dictionary<String, AnyObject> {
                    // do whatever with jsonResult
                    
                    print(array["title"]!)
                    let titleHead = array["title"] as? String
                    searchResults.append(Country(title: titleHead))
                    
                    //let rows = array["rows"] as? [Array]
                    if let rows = array["rows"] {
                        countryDetails.removeAll()
                        
                        for element in rows as! Array<AnyObject> {
                            print(element)
                            let dict = element as? [String: Any]
                            print(dict!)
                            countryDetails.append(CountryDetails(title: (dict!["title"] as? String ?? ""), description: (dict!["description"] as? String ?? ""), imageHref: (dict!["imageHref"] as? String ?? "")))
                        }
                        
                        // Update UI on main therad
                        DispatchQueue.main.sync {
                            updateUI()
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
    }
    
}

//Extensions
// MARK: - Private
private extension ViewController {
    func photo(for indexPath: IndexPath) -> PlacePhoto? {
        let imageUrlString = self.countryDetails[indexPath.row].imageHref
        let placePhoto = PlacePhoto.init(imageHerf: imageUrlString!)
        return placePhoto
    }
}



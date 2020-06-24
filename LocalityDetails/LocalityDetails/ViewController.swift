//
//  ViewController.swift
//  LocalityDetails
//
//  Created by fkhader on 6/23/20.
//  Copyright © 2020 fkhader. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var dataTask: URLSessionDataTask?
    var searchResults: [Country] = []
    var countryDetails: [CountryDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCountryDetails()
        print("test ")
    }

    func loadCountryDetails() {
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        let url = URL(string: "https://extendsclass.com/api/json-storage/bin/eadeffc")
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



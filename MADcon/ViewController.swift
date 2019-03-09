//
//  ViewController.swift
//  MADcon
//
//  Created by William X. on 3/5/19.
//  Copyright © 2019 Will Xu . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // references to the labels seen by the user
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // the important bits
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    let APIkey = "8ef111fa0a6c852cb9ae513502652867"
    let city = "Houston"
    
    // this is hand-waving magic
    var session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    // default methoc. Most work will COME from here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityLabel.text = self.city
        searchByCity(city: self.city)
    }
    
    // helper functions
    func addAPIkey(url: String) -> String {
        return url + "&appid=" + self.APIkey;
    }
    
    func addUnit(url: String, unit: String) -> String {
        return url + "&units=" + unit
    }
    
    func addCity(url: String, city: String) -> String {
        return url + "q=" + city
    }
    
    func makeBasicUrlString() -> String {
        let urlWithCity = addCity(url: self.baseUrl, city: self.city)
        let urlWithCityUnit = addUnit(url: urlWithCity, unit: "imperial")
        let urlWithCityUnitApi = addAPIkey(url: urlWithCityUnit)
        return urlWithCityUnitApi
    }
    // end helper functions
    
    // make the API call
    func searchByCity(city: String) {
        let callableUrlString = makeBasicUrlString()
        let callableUrl = URL(string: callableUrlString)!
        
        let request = URLRequest(url: callableUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let resp = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] {
                let main = resp["main"] as! [String: Double]
                self.temperatureLabel.text = "\(main["temp"]!)" + "°"
            }
        }
        task.resume()
    }
}

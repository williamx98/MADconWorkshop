//
//  ViewController.swift
//  MADcon
//
//  Created by William X. on 3/5/19.
//  Copyright © 2019 Will Xu . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    let APIkey = "8ef111fa0a6c852cb9ae513502652867"
    let city = "Houston"
    
    var session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cityLabel.text = self.city
        searchByCity(city: self.city)
    }
    
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

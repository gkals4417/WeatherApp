//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/09.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var citynameLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    
    var datas: Welcome?{
        didSet {
            configure()
        }
    }
    
    func configure(){
        guard let datas = datas else {return}
        citynameLabel.text = "지역 : \(datas.name)"
        humidityLabel.text = "습도 : \(String(describing: datas.main.humidity))"
        temperatureLabel.text = "기온 : \(String(describing: datas.main.temp))"
        highTemperatureLabel.text = "최고 기온 : \(String(describing: datas.main.tempMax))"
        lowTemperatureLabel.text = "최저 기온 : \(String(describing: datas.main.tempMin))"
    }
    

}

//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/11.
//

import UIKit
import WeatherKit
import CoreLocation

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    
    var datas: CurrentWeather?{
        didSet {
            configureCell()
        }
    }
    
    func configureCell(){
        guard let datas = datas else {return}
        let tempHumidity = (datas.humidity) * 100
        let tempTemperature = datas.temperature.converted(to: .celsius).formatted()
        let tempFeelsLike = datas.apparentTemperature.converted(to: .celsius).formatted()
        temperatureLabel.text = tempTemperature
        feelsLikeLabel.text = tempFeelsLike
        humidityLabel.text = "\(String(format: "%.1f", tempHumidity)) %"
        
        switch datas.condition {
        case .clear:
            conditionImageView.image = UIImage(named: "01d")
        case .mostlyClear:
            conditionImageView.image = UIImage(named: "02d")
        case .cloudy:
            conditionImageView.image = UIImage(named: "03d")
        case .mostlyCloudy:
            conditionImageView.image = UIImage(named: "04d")
        case .rain:
            conditionImageView.image = UIImage(named: "09d")
        case .heavyRain:
            conditionImageView.image = UIImage(named: "10d")
        case .thunderstorms:
            conditionImageView.image = UIImage(named: "11d")
        case .snow:
            conditionImageView.image = UIImage(named: "13d")
        case .haze:
            conditionImageView.image = UIImage(named: "50d")
        default:
            conditionImageView.image = UIImage(named: "02d")
        }
    }

    
}

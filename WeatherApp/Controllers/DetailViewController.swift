//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/16.
//

import UIKit
import WeatherKit

class DetailViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var viewDistanceLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    var datas: CurrentWeather? {
        didSet {
            configureUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "darkNavi")
        
    }
    
    func configureUI(){
        guard let datas = datas else {return}
        let tempHumidity = (datas.humidity) * 100
        let tempVisibility = datas.visibility.converted(to: .kilometers).formatted()
        let tempFeelsLike = datas.apparentTemperature.converted(to: .celsius).formatted()
        let tempTemperature = datas.temperature.converted(to: .celsius).formatted()
        let tempDewPoint = datas.dewPoint.converted(to: .celsius).formatted()
        let tempPressure = datas.pressure.converted(to: .hectopascals).formatted()
        let tempWindDirection = datas.wind.direction.converted(to: .degrees).formatted()
        let tempWindSpeed = datas.wind.speed.converted(to: .kilometersPerHour).formatted()
        
        humidityLabel.text = "\(String(format: "%.1f", tempHumidity)) %"
        feelsLikeLabel.text = tempFeelsLike
        temperatureLabel.text = tempTemperature
        dewPointLabel.text = tempDewPoint
        pressureLabel.text = tempPressure
        uvIndexLabel.text = "\(datas.uvIndex.category)"
        viewDistanceLabel.text = tempVisibility
        windDirectionLabel.text = tempWindDirection
        windSpeedLabel.text = tempWindSpeed

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

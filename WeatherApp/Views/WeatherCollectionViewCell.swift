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
    @IBOutlet weak var conditionImageView: UIImageView!
    
    var id: String = ""
    
    var datas: Welcome?{
        didSet {
            configureCell()
        }
    }
    
    private func configureCell(){
        guard let datas = datas else {return}
        citynameLabel.text = "지역 : \(datas.name)"
        humidityLabel.text = "습도 : \(String(describing: datas.main.humidity))"
        temperatureLabel.text = "기온 : \(String(describing: datas.main.temp))"
        highTemperatureLabel.text = "최고 기온 : \(String(describing: datas.main.tempMax))"
        lowTemperatureLabel.text = "최저 기온 : \(String(describing: datas.main.tempMin))"
        
        switch datas.weather[0].id{
        case 200...232:
            id = "11d"
            conditionImageView.image = UIImage(named: id)
        case 300...321:
            id = "10d"
            conditionImageView.image = UIImage(named: id)
        case 500...531:
            id = "09d"
            conditionImageView.image = UIImage(named: id)
        case 600...622:
            id = "13d"
            conditionImageView.image = UIImage(named: id)
        case 701...781:
            id = "50d"
            conditionImageView.image = UIImage(named: id)
        case 800:
            id = "01d"
            conditionImageView.image = UIImage(named: id)
        case 801...804:
            id = "04d"
            conditionImageView.image = UIImage(named: id)
        default:
            id = "02d"
            conditionImageView.image = UIImage(named: id)
        }
    }
    

}

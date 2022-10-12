//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/09.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    var id: String = ""
    
    var datas: Welcome?{
        didSet {
            configureCell()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "darkNavi")
        
    }

    private func configureCell(){
        guard let datas = datas else {return}
        locationNameLabel.text = "\(datas.name)"
        humidityLabel.text = "습도 | \(String(describing: datas.main.humidity)) %"
        temperatureLabel.text = "기온 | \(String(format: "%.1f", datas.main.temp)) ℃"
        maxTempLabel.text = "최고 기온 | \(String(format: "%.1f", datas.main.tempMax)) ℃"
        minTempLabel.text = "최저 기온 | \(String(format: "%.1f", datas.main.tempMin)) ℃"
        feelslikeLabel.text = "체감 온도 | \(String(format: "%.1f", datas.main.feelsLike)) ℃"
        pressureLabel.text = "기압 | \(String(describing: datas.main.pressure)) hPa"
        windSpeedLabel.text = "풍속 | \(String(describing: datas.wind.speed)) m/s"
        
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

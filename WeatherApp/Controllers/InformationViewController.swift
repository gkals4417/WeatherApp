//
//  InformationViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/16.
//

import UIKit
import WebKit
import MessageUI
import CoreLocation

class InformationViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()
    var locationAuthStatus = ""
    var settingArray: [String] = ["", "문의하기", "개인정보처리방침", "개발자 정보", "Weather"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        
//        UIGraphicsBeginImageContext(self.view.frame.size)
//                    UIImage(named: "background")?.draw(in: self.view.bounds)
//                    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//                    UIGraphicsEndImageContext()
//                    self.view.backgroundColor = UIColor(patternImage: image)
                
        locationAuthCheck()
    }
    
    
}

extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        var content = header.defaultContentConfiguration()
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 30)
        content.textProperties.color = UIColor(named: "darkNavi")!
        header.contentConfiguration = content
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "     Information"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = settingArray[indexPath.row]
        content.textProperties.font = .systemFont(ofSize: 20)
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
                    
        } else if indexPath.row == 1 {
            let email = "gkals4417@icloud.com"
            let subject = "문의하기"
            let mail = MFMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail(){
                mail.mailComposeDelegate = self
                mail.setToRecipients([email])
                mail.setSubject(subject)
                present(mail, animated: true)
            } else {
                
            }
        } else if indexPath.row == 2 {
            
            let vc = PrivacyWebViewController()
            vc.loadPrivacyHTML()
            vc.modalPresentationStyle = .popover
            present(vc, animated: true)
            
        } else if indexPath.row == 3 {
            let alert = UIAlertController(title: "개발자 정보", message: "Made by Pulsar\ngkals4417@icloud.com", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            let vc = PrivacyWebViewController()
            vc.loadWeatherKitPrivacyHTML()
            vc.modalPresentationStyle = .popover
            present(vc, animated: true)
        }
    }
}


extension InformationViewController: CLLocationManagerDelegate {
    func locationAuthCheck(){
        let status: CLAuthorizationStatus
                
        status = locationManager.authorizationStatus
    
        switch status {
        case .denied:
            locationAuthStatus = "위치정보 : 사용 안함"
            settingArray[0] = locationAuthStatus
        case .authorizedAlways, .authorizedWhenInUse, .restricted:
            locationAuthStatus = "위치정보 : 사용중"
            settingArray[0] = locationAuthStatus
        default:
            print("nil")
        }
    }
}

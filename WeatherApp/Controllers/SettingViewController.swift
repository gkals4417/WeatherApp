//
//  SettingViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit
import CoreLocation
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var settingTableView: UITableView!
    
    let weatherManager = WeatherManager.shared
    var locationManager = CLLocationManager()
    var locationAuthStatus = ""
    var settingArray:[String] = ["","문의하기", "개인 정보 처리 방침", "개발자 정보", "오픈 소스"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.dataSource = self
        settingTableView.delegate = self
        locationManager.delegate = self
        
        UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "background")?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        
        locationAuthCheck()
    }
    
}


// MARK: - Extensioin : TableView DataSource & Delegate

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        header.textLabel?.textColor = UIColor(named: "darkNavi")
        header.textLabel?.frame = header.frame
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "   Setting"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.textLabel?.text = settingArray[indexPath.row]
        
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
            let vc = WebViewController()
            vc.modalPresentationStyle = .popover
            present(vc, animated: true)
            
        } else if indexPath.row == 3 {
            let alert = UIAlertController(title: "개발자 정보", message: "Made by Pulsar", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "오픈 소스", message: "openweathermap.org", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Extension : CoreLocation Delegate

extension SettingViewController: CLLocationManagerDelegate{
    func locationAuthCheck(){
        let status: CLAuthorizationStatus
        
        if #available(iOS 14, *){
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
    
        switch status {
        case .denied:
            locationAuthStatus = "위치정보 : 사용 안함"
            settingArray[0] = locationAuthStatus
        case .authorizedAlways, .authorizedWhenInUse, .restricted:
            locationAuthStatus = "위치정보 : 사용중"
            settingArray[0] = locationAuthStatus
        default:
            print("NULL")
        }
    }
}

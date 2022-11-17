//
//  PrivacyWebView]Controller.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/17.
//

import UIKit
import WebKit

class PrivacyWebViewController: UIViewController {

    let webView = WKWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadPrivacyHTML(){
        guard let localFilePath = Bundle.main.url(forResource: "개인정보처리방침", withExtension: "html") else {return}
        
        let request = URLRequest(url: localFilePath)
        webView.loadFileURL(localFilePath, allowingReadAccessTo: localFilePath)
        webView.load(request)
    }

    func loadWeatherKitPrivacyHTML(){
        guard let localFilePath = Bundle.main.url(forResource: "Weather - Data Sources", withExtension: "html") else {return}
        
        let request = URLRequest(url: localFilePath)
        webView.loadFileURL(localFilePath, allowingReadAccessTo: localFilePath)
        webView.load(request)
    }
    
}

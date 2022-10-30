//
//  WebViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/30.
//

import UIKit
import WebKit


class WebViewController: UIViewController {

    let webView = WKWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        guard let localFilePath = Bundle.main.url(forResource: "개인정보처리방침", withExtension: "html") else {return}
        let request = URLRequest(url: localFilePath)
        webView.loadFileURL(localFilePath, allowingReadAccessTo: localFilePath)
        webView.load(request)
    }
    



}

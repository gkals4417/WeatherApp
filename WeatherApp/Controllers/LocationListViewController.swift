//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    let weatherManager = WeatherManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.dataSource = self
        locationTableView.delegate = self
    }
    

}

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherManager.getLocationDatasFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "toLocationListVC", for: indexPath) as! LocationListCell
    }
    
    
}

# ☀️날씨보여줭.app

## Project Introduction

**제 1회 iOS 1인 해커톤 - with 루나 at the 앨런 스쿨**에 참가해서 만든 간단 Current 날씨 앱 입니다.
<br/>

>대회 기간 : 2022년 10월 5일 ~ 2022년 10월 14일<br/>
>개발 기간 : 2022년 10월 5일 ~ 2022년 10월 11일<br/>
>참여 인원 : Pulsar ([github](https://github.com/gkals4417/gkals4417)) ([blog](https://velog.io/@gkals4417))

>대회 이후 현재 추가 개발중...(afterEvent branch)<br/>

## Environment<br/>

<div align=left>
   <a href="https://developer.apple.com/kr/swift/"><img src="https://img.shields.io/badge/Swift5-FFFFFF?style=flat&logo=Swift&logoColor=F05138"/></a>
   <br/>
   <img src="https://img.shields.io/badge/Xcode 14.0.1-FFFFFF?style=flat&logo=Xcode&logoColor=147EFB"/></a>
   <br/>
   <a href="https://developer.apple.com/documentation/uikit"><img src="https://img.shields.io/badge/UIKit-FFFFFF?style=flat"/></a>
   <br/>
   <a href="https://github.com/jonkykong/SideMenu#readme"><img src="https://img.shields.io/badge/SideMenu-FFFFFF?style=flat"/></a>
   <br/>
   <img src="https://img.shields.io/badge/MacbookPro M1 Ultra-FFFFFF?style=flat"/></a>
</div> 

## Preview

|SideMenu & TableView|CollectionView|CoreLocation|Detail Information|TableView & MessageUI|
|--------------------|--------------|------------|------------------|---------------------|
|![1](https://user-images.githubusercontent.com/70322435/195484901-ef9fcef5-62e9-4337-ba22-d1fdda9f83ef.gif)|![2](https://user-images.githubusercontent.com/70322435/195484951-752de76e-4970-46db-8671-e4a8fc751459.gif)|![3](https://user-images.githubusercontent.com/70322435/195484969-9f983cd9-36e8-4e9c-9d08-6800a8579abc.gif)|![RPReplay_Final1665639877](https://user-images.githubusercontent.com/70322435/195511937-315688e1-2453-4477-a247-878ab0a0621e.gif)|![4](https://user-images.githubusercontent.com/70322435/195484982-bd4a39d5-80e7-4be2-9bf2-acdce4a5e2d5.gif)|

### [SideMenu](https://github.com/jonkykong/SideMenu#readme)
* 지역 추가, 제거를 하기 위한 기능으로 굳이 새로운 tableView를 전체화면으로 띄우는 것보다, 작은 화면으로 나왔다가 사라지는 방법이 더 깔끔하다고 생각되어서 채택했습니다.<br/>
* MainViewController의 확장으로 SideMenu Delegate를 이용하여, SideMenu가 사라지면 자동으로 MainViewController의 collectionView를 새로고침하도록 했습니다.
```swift
extension MainViewController: SideMenuNavigationControllerDelegate{
   func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool){
      collectionView.reloadData()
   }
}
```
### CollectionView
* 메인 화면에는 저장된 지역의 기본 정보를 보여지게 했습니다.<br/>
* CollectionView의 Cell을 전체 화면으로 한 뒤, Scroll Direction을 Horizontal로 해서 좌, 우로 넘길 수 있게 했습니다.<br/>
* 지역을 수동으로 추가하거나, GPS를 이용해서 지역이 추가되면, 그 지역이 CollectionView의 제일 첫번째로 오게 했습니다.
```swift
self.weatherDatasArray.insert(successData, at: 0)
```

### CoreLocation
* 날씨 어플리케이션에서는 현재 위치를 파악하는 것이 필수이기 때문에, CoreLocation 라이브러리를 이용했습니다.<br/>
* 위치를 파악하는 방법으로 latitude와 longitude값을 얻어서 외부 API로 값을 넘기는 방식을 선택했습니다. (수동으로 지역을 추가하는 경우, 지역 이름을 외부 API로 값을 넘겼습니다.)
```swift
extension MainViewController: CLLocationManagerDelegate{
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
      guard let location = locations.last else {return}
      locationManager.stopUpdatingLocation()
      lat = location.coordinate.latitude
      lon = location.coordinate.longitude
   }
}
```
### Detail Information
* SideMenu의 지역 cell을 선택하면 상세 날씨 정보를 확인할 수 있게 했습니다.<br/>
* 상세 정보의 경우, tableView의 indexPath.row를 이용하여 선택한 지역을 상세 정보로 나올 수 있게 했습니다.<br/>
* SideMenu의 tableViewController에 prepare를 이용하여 날씨 정보를 Detail Information의 viewController로 넘기고, 속성감시자를 통해 날씨 정보의 변동이 생기면 화면에 데이터를 업데이트하도록 했습니다.
```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?){
   if segue.identifier == "toDetailVC"{
      let detailVC = segue.destination as! DetailViewController
      let index = sender as! IndexPath
      DispatchQueue.main.async{
         detailVC.datas = self.weatherManager.weatherDatasArray[index.row]
      }
   }
}
```
```swift
var datas: Welcome?{
   didSet{
      configureCell()
   }
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
}
```
### TableView & MessageUI
* 탭바에 setting을 추가하여 위치 확인 동의 여부, 개발자 정보, API정보, 문의하기를 tableView로 추가했습니다.<br/>
```swift
//위치 확인 동의 여부
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
```
* 문의하기의 경우, 터치를 하면 바로 개발자의 이메일로 메일을 보낼 수 있게 MessageUI 라이브러리를 선택했습니다.
```swift
func tableView(_ tableView: UItableView, didSelectRowAt indexPath: IndexPath){
   if indexPath.row == 1 {
      let email = "gkals4417@icloud.com"
      let subject = "문의하기"
      let mail = MFMailComposeViewController()
      
      if MFMailComposeViewController.canSendMail(){
         mail.mailComposeDelegate = self
         mail.setToRecipients([email])
         mail.setSubject(subject)
         present(mail, animated: true)
      }
   }
}
```

## Structure

MVC Pattern<br/>
├── WeatherApp<br/>
&nbsp;&nbsp;&nbsp;   ├─ SavedLocationData.xcdatamodeld<br/>
&nbsp;&nbsp;&nbsp;   ├─ AppDelegate.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ SceneDelegate.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ Assets.xcassets<br/>
&nbsp;&nbsp;&nbsp;   ├─ LaunchScreen.storyboard<br/>
&nbsp;&nbsp;&nbsp;   ├─ Info.plist<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Helpers**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ Constants.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Models**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SavedLocationData+CoreDataClass.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SavedLocationData+CoreDataProperties.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ CoreDataManager.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WeatherManager.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WeatherModel.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ WeatherNetworkManager.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Views**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ Main.storyboard<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ LocationListCell.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SettingCell.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ WeatherCollectionViewCell.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Controllers**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ MainViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ LocationListViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SettingViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ DetailViewController.swift<br/>
<br/>
<img width="849" alt="Screenshot 2022-10-13 at 2 33 53 PM" src="https://user-images.githubusercontent.com/70322435/195510181-d3d5dc8d-9d31-420f-9121-e0fa15dfc798.png">

## Troubles & Solution

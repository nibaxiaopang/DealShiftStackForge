//
//  ViewController.swift
//  DealShiftStackForge
//
//  Created by DealShiftStackForge on 2024/11/14.
//

import UIKit
import AdjustSdk
import Reachability

extension Notification.Name {
    static let StackForgeATTracking = Notification.Name("StackForgeATTracking")
}

class StackForgeHomeViewController: UIViewController {
    
    @IBOutlet weak var eliteActivityView: UIActivityIndicatorView!
    
    var sAds: Bool = false
    
    var adid: String?{
        didSet {
            if adid != nil {
                StackConfigADSData()
            }
        }
    }
    var idfa: String? {
        didSet {
            if idfa != nil {
                StackConfigADSData()
            }
        }
    }
    
    var adStr: String? {
        didSet {
            if adStr != nil {
                StackConfigADSData()
            }
        }
    }
    
    var aceReachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.eliteActivityView.hidesWhenStopped = true
        self.StackADsBannData()
        
        Adjust.adid { adidTm in
            DispatchQueue.main.async {
                self.adid = adidTm
            }
        }
        
        NotificationCenter.default.addObserver(forName: .StackForgeATTracking, object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                self.idfa = self.stackRequestIDFA()
            }
        }
    }

    private func StackADsBannData() {
        guard self.stackNeedShowAdsBann() else {
            return
        }
        
        if let adsData = UserDefaults.standard.value(forKey: "StackForgeADSDataList") as? [String: Any] {
            if let adsStr = adsData["adsStr"] as? String {
                self.adStr = adsStr
                self.StackConfigADSData()
                return
            }
        }
        
        do {
            aceReachability = try Reachability()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        self.eliteActivityView.startAnimating()
        if aceReachability.connection == .unavailable {
            aceReachability.whenReachable = { reachability in
                self.aceReachability.stopNotifier()
                self.StackLoadadsBann()
            }

            aceReachability.whenUnreachable = { _ in
            }

            do {
                try aceReachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
        } else {
            self.StackLoadadsBann()
        }
    }
    
    private func StackLoadadsBann() {
        self.StackPostDeviceData { adsData in
            self.eliteActivityView.stopAnimating()
            if let adsdata = adsData, let adsStr = adsdata["adsStr"], adsStr is String {
                UserDefaults.standard.setValue(adsdata, forKey: "StackForgeADSDataList")
                self.adStr = adsStr as? String
                self.StackConfigADSData()
            }
        }
    }
    
    private func StackConfigADSData() {
        if let adsStr = self.adStr, let adid = self.adid, let idfa = self.idfa , sAds == false{
            sAds = true
            print("hahha: \(adsStr)?gpsid=\(idfa)&deviceid=\(adid)")
            self.stackShowBannersView("\(adsStr)?gpsid=\(idfa)&deviceid=\(adid)", adid: adid, idfa: idfa)
        }
    }
    
    private func StackPostDeviceData(completion: @escaping ([String: Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://o\(self.stackHostMainURL())/open/StackPostDeviceData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "appDeviceModel": self.stackDeviceModel(),
            "appKey": "fb5d3ce5690d41729eadc480f8aab5b6",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        let jsonAdsData: [String: Any]? = dictionary?["jsonObject"] as? Dictionary
                        if let dataDic = jsonAdsData {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }

}


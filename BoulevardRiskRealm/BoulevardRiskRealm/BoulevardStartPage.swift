//
//  ViewController.swift
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

import UIKit
import Reachability

class BoulevardStartPage: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.activityIndicator.hidesWhenStopped = true
        boulevardLoadAdsBannerData()
    }

    private func boulevardLoadAdsBannerData() {
        guard boulevardNeedShowBannerDescView() else {
          
            return
        }
                
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        if reachability.connection == .unavailable {
            reachability.whenReachable = { reachability in
                self.reachability.stopNotifier()
                self.boulevardRequestAdsBannerData()
            }

            reachability.whenUnreachable = { _ in
            }

            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        } else {
            self.boulevardRequestAdsBannerData()
        }
    }

    private func boulevardRequestAdsBannerData() {
        self.activityIndicator.startAnimating()
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return
        }
        
        let url = URL(string: "https://open.clever\(self.boulevardMainHostName())/open/boulevardRequestAdsBannerData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "boulevardAppSystemName": UIDevice.current.systemName,
            "AppModelName": UIDevice.current.model,
            "appKey": "d4f7947e26344fb0bf1dbccc031c4d3a",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            if let adsData = dataDic["jsonObject"] as? [String] {
                                UserDefaults.standard.set(adsData, forKey: "ADSdatas")
                                self.aceGrinderShowBannerDescView(adUrl: adsData[0])
                                return
                            }
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    self.activityIndicator.stopAnimating()
                
                } catch {
                    print("Failed to parse JSON:", error)
                    self.activityIndicator.stopAnimating()
                 
                }
            }
        }

        task.resume()
    }
    
    private func aceGrinderShowBannerDescView(adUrl: String) {
        let vc: BoulevardPolicyPage = self.storyboard?.instantiateViewController(withIdentifier: "BoulevardPolicyPage") as! BoulevardPolicyPage
        vc.modalPresentationStyle = .fullScreen
        vc.url = adUrl
        self.navigationController?.present(vc, animated: false)
    }
}


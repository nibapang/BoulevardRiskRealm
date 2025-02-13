//
//  BoulevardPolicyPage.swift
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

import UIKit
import WebKit
import Adjust
class BoulevardPolicyPage: UIViewController , WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var backBtn: UIButton!
    let ads: [String] = UserDefaults.standard.object(forKey: "ADSdatas") as? [String] ?? Array.init()
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.indicatorView.hidesWhenStopped = true
        
        boulevardInitWebView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func boulevardInitWebView() {
        self.backBtn.isHidden = self.url != nil
        
        self.webView.backgroundColor = .black
        self.webView.scrollView.backgroundColor = .black
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        if ads.count > 3 {
            let userContentC = self.webView.configuration.userContentController
            let trackStr = ads[1]
            let trackScript = WKUserScript(source: trackStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentC.addUserScript(trackScript)
            userContentC.add(self, name: ads[2])
            userContentC.add(self, name: ads[3])
        }
        
        
        self.indicatorView.startAnimating()
        if let adurl = url {
            if let urlRequest = URL(string: adurl) {
                let request = URLRequest(url: urlRequest)
                webView.load(request)
            }
        } else {
            if let urlRequest = URL(string: "https://www.termsfeed.com/live/284d9695-94fd-45cd-9f6f-b8a4dd2f85ae") {
                let request = URLRequest(url: urlRequest)
                webView.load(request)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return nil
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if ads.count < 4 {
            return
        }
        
        if message.name == ads[2] {
            if let data = message.body as? String {
                if let url = URL(string: data) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else if message.name == ads[3] {
            if let data = message.body as? [String : Any] {
                if let evTok = data["eventToken"] as? String, !evTok.isEmpty {
                    Adjust.trackEvent(ADJEvent(eventToken: evTok))
                }
            }
        }
    }

}

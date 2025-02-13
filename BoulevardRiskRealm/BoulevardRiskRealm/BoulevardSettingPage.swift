//
//  SettingVC.swift
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

import Foundation
import UIKit
import StoreKit

class BoulevardSettingPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
}

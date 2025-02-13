//
//  UIViewController+back.swift
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

import Foundation
import UIKit

extension UIViewController {
    @IBAction func BackBtnTapped (_ sender : Any) {
        navigationController?.popViewController(animated: true)
    }
}

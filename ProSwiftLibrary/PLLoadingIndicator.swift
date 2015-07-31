//
//  PLMBProgressHUD.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/28/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showLoadingIndicator() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func hideLodingIndicator() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}
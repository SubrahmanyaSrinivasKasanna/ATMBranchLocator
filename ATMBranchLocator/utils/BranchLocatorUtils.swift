//
//  ATMBranchLocatorUtils.swift
//  ATMBranchLocator
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import Foundation
import UIKit

/***
 Utils class contains the all reusable methods those can used across the application where ever we need to do some task.
 ***/

class BranchLocatorUtils{
/**
 To show the alert in the application
 - parameter controller:  Controller which need to display alert
 - parameter title:  Title for alert
 - parameter message:  Message for alert
 */
    static func showAlert(controller: UIViewController, title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
        (result : UIAlertAction) -> Void in
        }
    
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func callToNumber(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }

}
//For Unit testing purpose
extension BranchLocatorUtils{
    
    static func loadVCFromStoryboard(storyboard storyboardName: String,  vcIdentifier: String) -> UIViewController?{
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier)
        return vc
    }
}

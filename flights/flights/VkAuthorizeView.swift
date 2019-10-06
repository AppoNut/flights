//
//  ViewController.swift
//  flights
//
//  Created by Aleksandr Gusev on 06/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import UIKit
import Foundation
import VK_ios_sdk


class VkAuthorizeView: UIViewController  {

    private var VKAuthController: VkAuthorizeController?
    private var vkObj: VkDelegate?
    var vkRelatedData = VkRelatedData.init()
    let vkApiVersion: String = "5.101"
    var readyToShowMenu = false
    var vkAuthLogging: Logging = Logging()

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Load VK view */
        vkObj = VkDelegate.init(self)
        
        vkAuthLogging.setLoggingStatus(newStatus: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vkAuthLogging.logToConsole(logMessage: "readyToShowMenu \(readyToShowMenu)")
        if readyToShowMenu == true {
            displayMenuController()
        }
    }

    @IBAction func vkSignInButton(_ sender: Any) {
        vkAuthLogging.logToConsole(logMessage: "vkSignInButton")
        vkObj!.vkButtonPressed()
        if let vkWebVIew = vkObj!.getWebViewController() {
            vkAuthLogging.logToConsole(logMessage: "webkit")
            present(vkWebVIew, animated: true, completion: nil)
        }
        vkAuthLogging.logToConsole(logMessage:
            "token: [\(String(describing: VKSdk.accessToken()?.accessToken))]")
        if let gotToken = VKSdk.accessToken()?.accessToken {
            self.vkRelatedData.setToken(value: "\(gotToken)")
            vkAuthLogging.logToConsole(logMessage: "gotToken: [\(gotToken)]")
        }
        vkAuthLogging.logToConsole(logMessage: "vkSignInButton")
        displayMenuController()
    }

    func displayMenuController() {
        vkAuthLogging.logToConsole(logMessage: "displayMenuController")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMainView", sender: nil)
        }
    }
}

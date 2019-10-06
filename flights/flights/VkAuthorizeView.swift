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

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Load VK view */
        vkObj = VkDelegate.init(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("readyToShowMenu \(readyToShowMenu)")
        if readyToShowMenu == true {
            displayMenuController()
        }
    }

    @IBAction func vkSignInButton(_ sender: Any) {
        //VKAuthController?.logout()
        print ("vkSignInButton");
        vkObj!.vkButtonPressed()
        if let vkWebVIew = vkObj!.getWebViewController() {
            print("webkit")
            present(vkWebVIew, animated: true, completion: nil)
        }
        print("token: [\(String(describing: VKSdk.accessToken()?.accessToken))]")
        if let gotToken = VKSdk.accessToken()?.accessToken {
            self.vkRelatedData.setToken(value: "\(gotToken)")
            print("gotToken: [\(gotToken)]")
        }
        print("vkSignInButton")
        displayMenuController()
    }

    func displayMenuController() {
        print("displayMenuController")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMainView", sender: nil)
        }
    }
}

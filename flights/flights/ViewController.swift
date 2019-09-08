//
//  ViewController.swift
//  flights
//
//  Created by Aleksandr Gusev on 06/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController/*, VKSdkDelegate, VKSdkUIDelegate*/  {
    private var vkObj: VkApiClass?

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Load VK view */
        vkObj = VkApiClass.init(self)
        // Do any additional setup after loading the view.
    }

    @IBAction func vkSignInButton(_ sender: Any) {
        print ("vkSignInButton");
        vkObj!.vkButtonPressed()
        if let vkWebVIew = vkObj!.getWebViewController() {
            present(vkWebVIew, animated: true, completion: nil)
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "mainMenuView"))!
        self.present(vc, animated: true, completion: nil)
    }

}


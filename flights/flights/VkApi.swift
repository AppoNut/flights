//
//  VkApi.swift
//  flights
//
//  Created by Aleksandr Gusev on 06/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VkApiClass : ViewController, VKSdkDelegate, VKSdkUIDelegate  {
    private let APP_ID = ""
    
    var vkApiView: ViewController?
    
    init (_ controller: ViewController) {
        vkApiView = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func vkButtonPressed(){
        print ("vkButtonPressed")
        
        let sdkInstance = VKSdk.initialize(withAppId: APP_ID)
        sdkInstance!.register(self);
        sdkInstance!.uiDelegate = self;
        VKSdk.initialize(withAppId: APP_ID)?.register(self)
        
        
        self.initWorkingBlock { (finished) -> Void in
            // пользователь авторизован
            //VKSdk.forceLogout()
            print("user has been authorized")
        }
    }
    
    func initWorkingBlock (_ completion: ((Bool) -> Void)!){
        print ("initWorkingBlock")
        let scope = ["wall"]
        
        VKSdk.wakeUpSession(scope, complete: { (state, error) -> Void in
            if (state == VKAuthorizationState.authorized) {
                print("Authorized and ready to go")
            } else if ((error) != nil) {
                print("Some error happend, but you may try later: \(error)")
            } else {
                VKSdk.authorize(scope)
            }
            completion(true)
            self.vkGetUser()
            print("completion VKSdk.wakeUpSession")
        })
    }
    
    func vkGetUser(){
        print ("vkGetUser")
        if VKSdk.isLoggedIn() {
            let userId = VKSdk.accessToken().userId
            print("\(userId)")
            if (userId != nil) {
                VKApi.users().get([VK_API_FIELDS:"first_name, last_name",
                                   VK_API_USER_ID: userId!]).execute(resultBlock: { (response) -> Void in
                                    
                                    print("\n \(response?.parsedModel.fields) \n")
                                    //var user: VKUser = response?.json as! VKUser
                                    print("user: \(response?.json)")
                                    /*do {
                                        let jsonResponse = try JSONSerialization.jsonObject(with: response, options: [])
                                    print("jsonResponse: \(jsonResponse)")
                                    } catch let parsingError {
                                        print("parsing error: \(parsingError)")
                                    }*/
                                    /*if let user = response?.parsedModel.fields[0] != nil {
                                        print("Пользователь ВК: \(user)")
                                    }*/
                                    
                                   }, errorBlock: { (error) -> Void in
                                    print("Error2: \(error)")
                                   })
            }
        }
    }
    var webViewController : UIViewController?
    
    func getWebViewController() -> UIViewController? {
        return webViewController
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("vkSdkShouldPresent")
        // push safari web view controller manually
        webViewController = controller
        //present(controller!, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("vkSdkNeedCaptchaEnter")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("vkSdkAccessAuthorizationFinished")
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

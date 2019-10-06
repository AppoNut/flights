//
//  VkDelegate.swift
//  flights
//
//  Created by Aleksandr Gusev on 13/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VkDelegate:   VkAuthorizeView,
                    VKSdkDelegate,
                    VKSdkUIDelegate {

    private let APP_ID = ""
    var vkApiView: VkAuthorizeView?
    var vkDelegateLogging: Logging = Logging()
    
    init (_ controller: VkAuthorizeView) {
        vkApiView = controller
        super.init(nibName: nil, bundle: nil)
        
        vkDelegateLogging.setLoggingStatus(newStatus: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func vkButtonPressed(){
        vkDelegateLogging.logToConsole(logMessage: "vkButtonPressed")
        
        let sdkInstance = VKSdk.initialize(withAppId: APP_ID)
        sdkInstance!.register(self);
        sdkInstance!.uiDelegate = self;
        VKSdk.initialize(withAppId: APP_ID)?.register(self)
        
        
        self.initWorkingBlock { (finished) -> Void in
            // пользователь авторизован
            if finished == true {
                DispatchQueue.main.async {
                    self.vkDelegateLogging.logToConsole(logMessage: "OK")
                    //self.performSegue(withIdentifier: "toMainView", sender: nil)
                }
            }
            self.vkDelegateLogging.logToConsole(logMessage: "user has been authorized")
        }
    }
    
    func initWorkingBlock (_ completion: ((Bool) -> Void)!){
        self.vkDelegateLogging.logToConsole(logMessage: "initWorkingBlock")
        let scope = ["wall"]
        
        VKSdk.wakeUpSession(scope, complete: { (state, error) -> Void in
            if (state == VKAuthorizationState.authorized) {
                self.vkDelegateLogging.logToConsole(logMessage:
                    "Authorized and ready to go")
            } else if ((error) != nil) {
                self.vkDelegateLogging.logToConsole(logMessage:
                    "Some error happend, but you may try later: \(error)")
            } else {
                VKSdk.authorize(scope)
                self.vkDelegateLogging.logToConsole(logMessage:
                    " is loggedIn:  \(VKSdk.isLoggedIn())")
            }
            
            self.vkGetUser()
            completion(true)
            self.vkDelegateLogging.logToConsole(logMessage:
                "completion VKSdk.wakeUpSession")
        })
    }
    
    func vkGetUser(){
        self.vkDelegateLogging.logToConsole(logMessage: "vkGetUser")
        if VKSdk.isLoggedIn() {
            let userId = VKSdk.accessToken().userId
            self.vkRelatedData.setUserId(value: "\(userId!)")
            self.vkDelegateLogging.logToConsole(logMessage: "\(userId)")
            if (userId != nil) {
                VKApi.users().get([VK_API_FIELDS:"first_name, last_name",
                                   VK_API_USER_ID: userId!]).execute(resultBlock: { (response) -> Void in
                                    
                                    self.vkDelegateLogging.logToConsole(logMessage:
                                        "\n \(response?.parsedModel.fields) \n")
                                    self.vkDelegateLogging.logToConsole(logMessage:
                                        "user: \(response?.json)")

                                    self.vkRelatedData.setApiVersion(value: self.vkApiVersion)
                                   }, errorBlock: { (error) -> Void in
                                        self.vkDelegateLogging.logToConsole(logMessage: "Error2: \(error)")
                                   })
            }
        }
    }
    var webViewController : UIViewController?
    
    func getWebViewController() -> UIViewController? {
        return webViewController
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.vkDelegateLogging.logToConsole(logMessage: "vkSdkShouldPresent")
        // push safari web view controller manually
        webViewController = controller
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        self.vkDelegateLogging.logToConsole(logMessage: "vkSdkNeedCaptchaEnter")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        vkApiView!.readyToShowMenu = true
        self.vkDelegateLogging.logToConsole(logMessage: "vkSdkAccessAuthorizationFinished")
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.vkDelegateLogging.logToConsole(logMessage: "vkSdkUserAuthorizationFailed")
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

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
    
    init (_ controller: VkAuthorizeView) {
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
            //self.performSegue(withIdentifier: "toMainView", sender: nil)
            if finished == true {
                DispatchQueue.main.async {
                    print("OK")
                    //self.performSegue(withIdentifier: "toMainView", sender: nil)
                }
            }
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
                print(" is loggedIn:  \(VKSdk.isLoggedIn())")
            }
            
            self.vkGetUser()
            completion(true)
            print("completion VKSdk.wakeUpSession")
        })
    }
    
    func vkGetUser(){
        print ("vkGetUser")
        if VKSdk.isLoggedIn() {
            let userId = VKSdk.accessToken().userId
            self.vkRelatedData.setUserId(value: "\(userId!)")
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
                                    
                                    self.vkRelatedData.setApiVersion(value: self.vkApiVersion)
                                    //self.vkRelatedData.setUserId(value: response?.json["user_id"]!)
                                    //self.vkRelatedData.setToken(value: info["access_token"]!)
                                    
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
        vkApiView!.readyToShowMenu = true
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

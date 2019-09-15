//
//  ViewController.swift
//  flights
//
//  Created by Aleksandr Gusev on 06/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import UIKit
import SwiftyVK
import Foundation


class VkAuthorizeView: UIViewController  {
   
    private var VKAuthController: VkAuthorizeController?
    var vkRelatedData = VkRelatedData.init()
    let vkApiVersion: String = "5.101"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VKAuthController = VkAuthorizeController.init()
    }

    @IBAction func vkSignInButton(_ sender: Any) {
        //VKAuthController?.logout()
        if authorize() {
            // do nothing
        }
    }

    func authorize() -> Bool {
        VK.sessions.default.logIn(
            onSuccess: { info in
                self.vkRelatedData.setApiVersion(value: self.vkApiVersion)
                self.vkRelatedData.setUserId(value: info["user_id"]!)
                self.vkRelatedData.setToken(value: info["access_token"]!)
                self.displayMenuController()
            },
            onError: { error in
                self.handleVkErrors(errorType: error)
            }
        )
        return true
    }
    
    func displayMenuController() {
        performSegue(withIdentifier: "toMainView", sender: nil)
    }
    
    func handleVkErrors(errorType: VKError) {
        switch (errorType) {
        case .sessionAlreadyAuthorized:
            //print("sessionAlreadyAuthorized")
            displayMenuController()
            break
        case .unknown(_):
            //print("unknown")
            break
        case .api(_):
            //print("api")
            break
        case .cantSaveToKeychain(_):
            //print("cantSaveToKeychain")
            break
        case .vkDelegateNotFound:
            //print("vkDelegateNotFound")
            break
        case .cantParseTokenInfo(_):
            //print("cantParseTokenInfo")
            break
        case .sessionAlreadyDestroyed(_):
            //print("sessionAlreadyDestroyed")
            break
        case .sessionIsNotAuthorized(_):
            //print("sessionIsNotAuthorized")
            break
        case .unexpectedResponse:
            //print("unexpectedResponse")
            break
        case .jsonNotParsed(_):
            //print("jsonNotParsed")
            break
        case .urlRequestError(_):
            //print("urlRequestError")
            break
        case .captchaResultIsNil:
            //print("captchaResultIsNil")
            break
        case .wrongUrl:
            //print("wrongUrl")
            break
        case .cantAwaitOnMainThread:
            //print("cantAwaitOnMainThread")
            break
        case .cantAwaitRequestWithSettedCallbacks:
            //print("cantAwaitRequestWithSettedCallbacks")
            break
        case .cantBuildWebViewUrl(_):
            //print("cantBuildWebViewUrl")
            break
        case .cantBuildVKAppUrl(_):
            //print("cantBuildVKAppUrl")
            break
        case .captchaPresenterTimedOut:
            //print("captchaPresenterTimedOut")
            break
        case .cantMakeCapthaImageUrl(_):
            //print("cantMakeCapthaImageUrl")
            break
        case .cantLoadCaptchaImage(_):
            //print("cantLoadCaptchaImage")
            break
        case .cantLoadCaptchaImageWithUnknownReason:
            //print("cantLoadCaptchaImageWithUnknownReason")
            break
        case .webPresenterTimedOut:
            //print("webPresenterTimedOut")
            break
        case .webPresenterResultIsNil:
            //print("webPresenterResultIsNil")
            break
        case .webControllerError(_):
            //print("webControllerError")
            break
        case .authorizationUrlIsNil:
            //print("authorizationUrlIsNil")
            break
        case .authorizationDenied:
            //print("authorizationDenied")
            break
        case .authorizationCancelled:
            //print("authorizationCancelled")
            break
        case .authorizationFailed:
            //print("authorizationFailed")
            break
        case .captchaWasDismissed:
            //print("captchaWasDismissed")
            break
        case .sharingWasDismissed:
            //print("sharingWasDismissed")
            break
        case .weakObjectWasDeallocated:
            //print("weakObjectWasDeallocated")
            break
        }
    }
}


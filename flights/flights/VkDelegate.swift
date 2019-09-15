//
//  VkDelegate.swift
//  flights
//
//  Created by Aleksandr Gusev on 13/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import SwiftyVK

class VkDelegate: SwiftyVKDelegate {
    
    private let APP_ID = ""
    let scopes: Scopes = [.wall]
    
    init() {
        VK.setUp(appId: APP_ID, delegate: self)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        //print("token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        //print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        //print("token removed in session \(sessionId)")
    }
}

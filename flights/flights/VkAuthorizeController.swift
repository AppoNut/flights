//
//  VkApi.swift
//  flights
//
//  Created by Aleksandr Gusev on 06/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import SwiftyVK

class VkAuthorizeController {
    
    var authorizeStatus = false
    
    func setStatus(status: Bool) {
        authorizeStatus = status
    }
    
    func getStatus() -> Bool {
        return authorizeStatus
    }

    func logout() {
        VK.sessions.default.logOut()
    }

}

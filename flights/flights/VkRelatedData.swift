//
//  VkRelatedData.swift
//  flights
//
//  Created by Aleksandr Gusev on 15/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation

/* VK session data storage */
class VkRelatedData {
    static private var apiVersion: String?
    static private var userId: String?
    static private var token: String?
    
    func getApiVersion() -> String {
        if VkRelatedData.apiVersion != nil {
            return VkRelatedData.apiVersion!
        }
        return ""
    }
    
    func setApiVersion(value: String) {
        VkRelatedData.apiVersion = value
    }
    
    
    func getUserId() -> String {
        if VkRelatedData.userId != nil {
            return VkRelatedData.userId!
        }
        return ""
    }
    
    func setUserId(value: String) {
        VkRelatedData.userId = value
    }
    
    func getToken() -> String {
        if VkRelatedData.token != nil {
            return VkRelatedData.token!
        }
        return ""
    }
    
    func setToken(value: String) {
        VkRelatedData.token = value
    }
    
}

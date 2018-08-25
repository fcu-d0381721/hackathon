//
//  ShareManager.swift
//  ANIMAP
//
//  Created by Winky_swl on 9/7/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import Foundation

class ShareManager {
    
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var subAdministrativeArea: String?
    var uid: String?
    var name: String?
    
    var sendEventAction = 0
    
    
    static let sharedInstance = ShareManager()
}

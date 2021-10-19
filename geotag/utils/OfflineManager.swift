//
//  OfflineManager.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//

import UIKit


final class OfflineManager: NSObject {
    static let shared = OfflineManager()
    
    var isProcessing = false
    
    private override init() {
        
    }
    
}

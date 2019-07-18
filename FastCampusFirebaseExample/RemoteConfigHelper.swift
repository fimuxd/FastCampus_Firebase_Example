//
//  RemoteConfigHelper.swift
//  FastCampusFirebaseExample
//
//  Created by Boyoung Park on 18/07/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Firebase

class RemoteConfigHelper {
    enum Configuration: String {
        case helloTextHidden = "hello_text_hidden"
        case helloText = "hello_text"
    }
    
    static let shared = RemoteConfigHelper()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    func setting() {
        // Debug mode 임을 명시
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        fetchConfig()
    }
    
    func get(type: Configuration) -> String? {
        return remoteConfig.configValue(forKey: type.rawValue).stringValue
    }
}

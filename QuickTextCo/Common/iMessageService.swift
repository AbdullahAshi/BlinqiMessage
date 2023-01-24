//
//  iMessageService.swift
//  iMessagesPersistance
//
//  Created by Abdullah Al-Ashi on 22/1/2023.
//

import Foundation
import Messages

protocol iMessageServiceProtocol {
    func saveiMessage(_ messages: [MSMessage])
    func loadiMessage() -> [MSMessage]
    
}

class iMessageService: iMessageServiceProtocol {
    
    private struct Constants {
        static let messagesKey = "com.QuickTextCo.messagesKey"
    }
    
    public static let shared = iMessageService()
    
    func saveiMessage(_ messages: [MSMessage]) {
//            let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.rderik.sharefriends")
//           let archiveURL = documentsDirectory?.appendingPathComponent("rderikFriends.json")
//            let encoder = JSONEncoder()
//            if let dataToSave = try? encoder.encode(messages) {
//                do {
//                    try dataToSave.write(to: archiveURL!)
//                } catch {
//                    // TODO: ("Error: Can't save Counters")
//                    return;
//                }
//            }
        UserDefaults(suiteName: "group.com.ashiTest.QuickTextCo")?.set(25, forKey: "Age")
        }
    
    func loadiMessage() -> [MSMessage] {
        print("load called")
        let userDefaultsValue = UserDefaults(suiteName: "group.com.ashiTest.QuickTextCo")?.object(forKey: Constants.messagesKey)

        let age = UserDefaults(suiteName: "group.com.ashiTest.QuickTextCo")?.integer(forKey: "Age")
        print(age)

//            let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.rderik.sharefriends")
//            guard let archiveURL = documentsDirectory?.appendingPathComponent("rderikFriends.json") else { return [MSMessage]() }
//
//            guard let codeData = try? Data(contentsOf: archiveURL) else { return [] }
//
//            let decoder = JSONDecoder()
//
//            let loadedFriends = (try? decoder.decode([MSMessage].self, from: codeData)) ?? [MSMessage]()
//
//            return loadedFriends
        return []
        }
}

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A struct that persists a history of ice creams to `UserDefaults`.
*/

import Foundation

protocol IceCreamHistoryProtocol {
    var iceCreams: [IceCream] { get }
    func save()
    func append(_ iceCream: IceCream)
}

class IceCreamHistory: IceCreamHistoryProtocol {

    // MARK: Properties
    
    private static let maximumHistorySize = 50

    private static let userDefaultsKey = "iceCreams"
    
    /// An array of previously created `IceCream`s.
    private(set) var iceCreams: [IceCream]

    private var count: Int {
        return iceCreams.count
    }

    private subscript(index: Int) -> IceCream {
        return iceCreams[index]
    }
    
    static let shared: IceCreamHistory = IceCreamHistory()
    
    // MARK: Initialization
    
    private init() {
        iceCreams = IceCreamHistory.load()
    }

    /// Loads previously created `IceCream`s and returns a `IceCreamHistory` instance.
    private static func load() -> [IceCream] {
        var iceCreams = [IceCream]()
        let defaults = UserDefaults(suiteName: "group.com.ashiTest.QuickTextCo")!
        
        if let savedIceCreams = defaults.object(forKey: IceCreamHistory.userDefaultsKey) as? [String] {
            iceCreams = savedIceCreams.compactMap { urlString in
                guard let url = URL(string: urlString) else { return nil }
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
                guard let queryItems = components.queryItems else { return nil }
                
                return IceCream(queryItems: queryItems)
            }
        }
        return iceCreams
    }
    
    /// Saves the history.

    func save() {
        // Save a maximum number ice creams.
        let iceCreamsToSave = iceCreams.suffix(IceCreamHistory.maximumHistorySize)
        
        // Map the ice creams to an array of URL strings.
        let iceCreamURLStrings: [String] = iceCreamsToSave.compactMap { iceCream in
            var components = URLComponents()
            components.queryItems = iceCream.queryItems
            return components.url?.absoluteString
        }
        
        let defaults = UserDefaults(suiteName: "group.com.ashiTest.QuickTextCo")!
        defaults.set(iceCreamURLStrings as AnyObject, forKey: IceCreamHistory.userDefaultsKey)
    }
    
    func append(_ iceCream: IceCream) {
        // Ensure that no duplicates are inserted into the history
        var newIceCreams = self.iceCreams.filter { $0 != iceCream }
        newIceCreams.append(iceCream)
        self.iceCreams = newIceCreams
    }

}

/// Extends `IceCreamHistory` to conform to the `Sequence` protocol so it can be used in for..in statements.

extension IceCreamHistory: Sequence {

    typealias Iterator = AnyIterator<IceCream>
    
    func makeIterator() -> Iterator {
        var index = 0
        
        return Iterator {
            guard index < self.iceCreams.count else { return nil }
            
            let iceCream = self.iceCreams[index]
            index += 1
            
            return iceCream
        }
    }
    
}

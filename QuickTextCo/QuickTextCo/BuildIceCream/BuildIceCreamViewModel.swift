//
//  BuildIceCreamViewModel.swift
//  QuickTextCo
//
//  Created by Abdullah Al-Ashi on 31/1/2023.
//

import Foundation
import UIKit

class BuildIceCreamViewModel {
    
    private(set) var prompt: String?
    
    var iceCream: IceCream? {
        didSet {
            guard let iceCream = iceCream else { return }
            
            // Determine the ice cream parts to show in the collection view.
            if iceCream.base == nil {
                iceCreamParts = Base.all.map { $0 }
                prompt = NSLocalizedString("Select a base", comment: "")
            } else if iceCream.scoops == nil {
                iceCreamParts = Scoops.all.map { $0 }
                prompt = NSLocalizedString("Add some scoops", comment: "")
            } else if iceCream.topping == nil {
                iceCreamParts = Topping.all.map { $0 }
                prompt = NSLocalizedString("Finish with a topping", comment: "")
            }
        }
    }
    
    /// An array of `IceCreamPart`s to show in the collection view.
    
    var iceCreamParts = [IceCreamPart]()
    
    func didSelectPartAndNotifyIfFinished(at index: Int, for iceCream: IceCream) -> Bool {
        
        let iceCreamPart = iceCreamParts[index]
        
        var iceCream = iceCream
        if let base = iceCreamPart as? Base {
            iceCream.base = base
        } else if let scoops = iceCreamPart as? Scoops {
            iceCream.scoops = scoops
        } else if let topping = iceCreamPart as? Topping {
            iceCream.topping = topping
        } else {
            assertionFailure("Unexpected type of ice cream part selected.")
        }
        
        if iceCream.isComplete {
            var history = IceCreamHistory.load()
            history.append(iceCream)
            history.save()
        }
        
        self.iceCream = iceCream
        
        return iceCream.isComplete
    }
}

//
//  IceCreamViewController+extension.swift
//  QuickTextCo
//
//  Created by Abdullah Al-Ashi on 28/1/2023.
//

import Foundation
import Messages
import iMessageExt
import MessageUI

extension IceCreamsViewController: BuildIceCreamViewControllerDelegate {
    
    private func presentViewController(iceCream: IceCream?) {
        // Remove any child view controllers that have been presented.
        
        let controller: UIViewController
        if let iceCream = iceCream {
            // Parse an `IceCream` from the conversation's `selectedMessage` or create a new `IceCream`.
           //let iceCream = IceCream(message: message) ?? IceCream()

           // Show either the in process construction process or the completed ice cream.
           if iceCream.isComplete {
               controller = instantiateCompletedIceCreamController(with: iceCream)
           } else {
               controller = instantiateBuildIceCreamController(with: iceCream)
           }
        } else {
            controller = instantiateBuildIceCreamController(with: IceCream())
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /// - Tag: ComposeMessage
    fileprivate func composeMessage(with iceCream: IceCream, caption: String, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()
        components.queryItems = iceCream.queryItems
        
        let layout = MSMessageTemplateLayout()
        layout.image = iceCream.renderSticker(opaque: true)
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }

    /// - Tag: InsertMessageInConversation
    func buildIceCreamViewController(_ controller: BuildIceCreamViewController, didSelect iceCreamPart: IceCreamPart) {
//        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        guard var iceCream = controller.iceCream else { fatalError("Expected the controller to be displaying an ice cream") }

        // Update the ice cream with the selected body part and determine a caption and description of the change.
        var messageCaption: String
        if let base = iceCreamPart as? Base {
            iceCream.base = base
            messageCaption = NSLocalizedString("Let's build an ice cream", comment: "")
        } else if let scoops = iceCreamPart as? Scoops {
            iceCream.scoops = scoops
            messageCaption = NSLocalizedString("I added some scoops", comment: "")
        } else if let topping = iceCreamPart as? Topping {
            iceCream.topping = topping
            messageCaption = NSLocalizedString("Our finished ice cream", comment: "")
        } else {
            fatalError("Unexpected type of ice cream part selected.")
        }

        // Create a new message with the same session as any currently selected message.
        let message = composeMessage(with: iceCream, caption: messageCaption, session: nil)

        
        
        // Add the message to the conversation.
//        conversation.insert(message) { error in
//            if let error = error {
//                print(error)
//            }
//        }

        // If the ice cream is complete, save it in the history.
        if iceCream.isComplete {
            var history = IceCreamHistory.load()
            history.append(iceCream)
            history.save()
            self.navigationController?.popViewController(animated: true)
        } else {
//            self.navigationController?.popViewController(animated: true)
//            self.presentViewController(iceCream: iceCream)
            controller.iceCream = iceCream
            controller.reload()
        }
        
        //dismiss()
    }
    
    func instantiateBuildIceCreamController(with iceCream: IceCream) -> UIViewController {
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: BuildIceCreamViewController.storyboardIdentifier)
            as? BuildIceCreamViewController
            else { fatalError("Unable to instantiate a BuildIceCreamViewController from the storyboard") }
        
        controller.iceCream = iceCream
        controller.delegate = self
        
        return controller
    }
    
    func instantiateCompletedIceCreamController(with iceCream: IceCream) -> UIViewController {
        // Instantiate a `BuildIceCreamViewController`.
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: CompletedIceCreamViewController.storyboardIdentifier)
            as? CompletedIceCreamViewController
            else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }
        
        controller.iceCream = iceCream
        
        return controller
    }
}

extension IceCreamsViewController: IceCreamsViewControllerDelegate {
    func iceCreamsViewControllerDidSelectAdd() {
        //delegate?.iceCreamsViewControllerDidSelectAdd()
        presentViewController(iceCream: nil)
    }
    
    func iceCreamsViewControllerDidSelectIceCream(_ iceCream: IceCream) {
        self.iceCream = iceCream
        presentViewController(iceCream: iceCream)
    }
}

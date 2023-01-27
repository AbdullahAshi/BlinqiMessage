//
//  ViewController.swift
//  QuickTextCo
//
//  Created by Abdullah Al-Ashi on 21/1/2023.
//

import UIKit
import Messages
import iMessageExt
import MessageUI

//class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {
class ViewController: UIViewController, IceCreamsViewControllerDelegate{
    func iceCreamsViewControllerDidSelectAdd(_ controller: IceCreamsViewController) {
        presentViewController(for: conversation, with: MSMessagesAppPresentationStyle.expanded)
    }
    
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view.
    //        let message = MSMessage()
    ////        let vc = MessagesViewController()
    //        iMessageService.shared.saveiMessage([])
    //    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    private func instantiateBuildIceCreamController(with iceCream: IceCream) -> UIViewController {
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: BuildIceCreamViewController.storyboardIdentifier)
            as? BuildIceCreamViewController
            else { fatalError("Unable to instantiate a BuildIceCreamViewController from the storyboard") }
        
        controller.iceCream = iceCream
        controller.delegate = self
        
        return controller
    }
    
    private func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    private func instantiateIceCreamsController() -> UIViewController {
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: IceCreamsViewController.storyboardIdentifier)
            as? IceCreamsViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    
    
    private func instantiateCompletedIceCreamController(with iceCream: IceCream) -> UIViewController {
        // Instantiate a `BuildIceCreamViewController`.
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: CompletedIceCreamViewController.storyboardIdentifier)
            as? CompletedIceCreamViewController
            else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }
        
        controller.iceCream = iceCream
        
        return controller
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Remove any child view controllers that have been presented.
        removeAllChildViewControllers()
        
        let controller: UIViewController
        if presentationStyle == .compact {
            // Show a list of previously created ice creams.
            controller = instantiateIceCreamsController()
        } else {
             // Parse an `IceCream` from the conversation's `selectedMessage` or create a new `IceCream`.
            let iceCream = IceCream(message: message) ?? IceCream()

            // Show either the in process construction process or the completed ice cream.
            if iceCream.isComplete {
                controller = instantiateCompletedIceCreamController(with: iceCream)
            } else {
                controller = instantiateBuildIceCreamController(with: iceCream)
            }
        }

        addChild(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        controller.didMove(toParent: self)
    }
    var conversation: MSConversation = MSConversation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentViewController(for: conversation, with: MSMessagesAppPresentationStyle.compact)
        //presentViewController(for: conversation, with: MSMessagesAppPresentationStyle.expanded)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTouchUp(_ sender: AnyObject) {
//        let composeVC = MFMessageComposeViewController()
//        composeVC.delegate = self
//        let msgLayout = MSMessageTemplateLayout()
//        msgLayout.caption = "something here"
//        let message = MSMessage()
//        message.layout = msgLayout
//        composeVC.message = message
//
//        guard MFMessageComposeViewController.canSendText() else {
//            print("Mail services are not available")
//            return
//        }
//
//        self.present(composeVC, animated: true, completion: nil)
        displayMessageInterface()
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        
        // Configure the fields of the interface.
        composeVC.recipients = ["3142026521"]
        composeVC.body = "I love Swift!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    
}

extension ViewController: BuildIceCreamViewControllerDelegate {
    
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
        let message = composeMessage(with: iceCream, caption: messageCaption, session: conversation.selectedMessage?.session)

        
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }

        // If the ice cream is complete, save it in the history.
//        if iceCream.isComplete {
            var history = IceCreamHistory.load()
            history.append(iceCream)
            history.save()
//        }
        
        //dismiss()
    }
    
    var message: MSMessage {
        let msgLayout = MSMessageTemplateLayout()
        msgLayout.caption = "something here"
        let message = MSMessage()
        message.layout = msgLayout
        return message
    }
}

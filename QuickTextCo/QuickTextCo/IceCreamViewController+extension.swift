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
        let controller: UIViewController
        if let iceCream = iceCream {
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
    
    func doneAddingIceCream() {
                    self.navigationController?.popViewController(animated: true)
                    self.reload()
    }
    
    func instantiateBuildIceCreamController(with iceCream: IceCream) -> UIViewController {
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: BuildIceCreamViewController.storyboardIdentifier)
            as? BuildIceCreamViewController
            else { fatalError("Unable to instantiate a BuildIceCreamViewController from the storyboard") }
        
        controller.delegate = self
        let viewModel = BuildIceCreamViewModel()
        viewModel.iceCream = iceCream
        controller.viewModel = viewModel
                
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

//
//  ViewController.swift
//  QuickTextCo
//
//  Created by Abdullah Al-Ashi on 21/1/2023.
//

import UIKit


class MessageBuilderViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            //presentViewController(for: conversation, with: MSMessagesAppPresentationStyle.expanded)
            
            let controller: UIViewController = instantiateIceCreamsController()

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
    
    private func instantiateIceCreamsController() -> UIViewController {
        
        let commonStoryboard = UIStoryboard.init(name: "common", bundle: nil)
        guard let controller = commonStoryboard.instantiateViewController(withIdentifier: IceCreamsViewController.storyboardIdentifier)
            as? IceCreamsViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = controller
        
        return controller
    }
    
}
//    
//    
//    
//    
//
//    
//    
//    //    override func viewDidLoad() {
//    //        super.viewDidLoad()
//    //        // Do any additional setup after loading the view.
//    //        let message = MSMessage()
//    ////        let vc = MessagesViewController()
//    //        iMessageService.shared.saveiMessage([])
//    //    }
//    
////    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//    }
//    
//
//    
//    
//    
//
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //presentViewController(for: conversation, with: MSMessagesAppPresentationStyle.expanded)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    @IBAction func onTouchUp(_ sender: AnyObject) {
////        let composeVC = MFMessageComposeViewController()
////        composeVC.delegate = self
////        let msgLayout = MSMessageTemplateLayout()
////        msgLayout.caption = "something here"
////        let message = MSMessage()
////        message.layout = msgLayout
////        composeVC.message = message
////
////        guard MFMessageComposeViewController.canSendText() else {
////            print("Mail services are not available")
////            return
////        }
////
////        self.present(composeVC, animated: true, completion: nil)
//        
//        
//        //displayMessageInterface()
//        
//        //presentViewController(for: conversation, with: MSMessagesAppPresentationStyle.compact)
//        //presentViewController(iceCream: nil)
//    
//        self.navigationController?.pushViewController(instantiateIceCreamsController(), animated: true)
//        
//    }
//    
//    
//    
//}
//
//

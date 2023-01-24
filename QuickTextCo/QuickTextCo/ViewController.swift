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
class ViewController: UIViewController{
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view.
    //        let message = MSMessage()
    ////        let vc = MessagesViewController()
    //        iMessageService.shared.saveiMessage([])
    //    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


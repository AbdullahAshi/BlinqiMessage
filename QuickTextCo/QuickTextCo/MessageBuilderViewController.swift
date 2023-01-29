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

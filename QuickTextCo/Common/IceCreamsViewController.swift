/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A `UICollectionViewController` that displays the history of ice creams as well as a cell
 that can be tapped to start the process of creating a new ice cream.
*/

import UIKit
import Messages
import iMessageExt
import MessageUI

class IceCreamsViewController: UICollectionViewController {
    
    var message: MSMessage {
        let msgLayout = MSMessageTemplateLayout()
        let message = MSMessage()
        message.layout = msgLayout
        return message
    }
    
    var iceCream: IceCream?
    
    var delegate: IceCreamsViewControllerDelegate?
    
//    func iceCreamsViewControllerDidSelectAdd() {
//        delegate?.iceCreamsViewControllerDidSelectAdd()
//    }
//
//    func iceCreamsViewControllerDidSelectIceCream(_ iceCream: IceCream) {
//        self.iceCream = iceCream
//        delegate?.iceCreamsViewControllerDidSelectIceCream(iceCream)
//    }
    

    

    /// An enumeration that represents an item in the collection view.

    enum CollectionViewItem {
        case iceCream(IceCream)
        case create
    }

    // MARK: Properties
    
    static let storyboardIdentifier = "IceCreamsViewController"

    private var items: [CollectionViewItem] = []
    
    private let stickerCache = IceCreamStickerCache.cache
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        // Map the previously completed ice creams to an array of `CollectionViewItem`s.
        super.init(coder: aDecoder)
        self.reload()
    }
    
    func reload() {
        let reversedHistory = IceCreamHistory.load().reversed()
        var items: [CollectionViewItem] = reversedHistory.map { .iceCream($0) }
        
        // Add `CollectionViewItem` that the user can tap to start building a new ice cream.
        items.insert(.create, at: 0)
        
        self.items = items
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        // The item's type determines which type of cell to return.
        switch item {
        case .iceCream(let iceCream):
            return dequeueIceCreamCell(for: iceCream, at: indexPath)
            
        case .create:
            return dequeueIceCreamAddCell(at: indexPath)
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        switch item {
        case .create:
            //iceCreamsViewControllerDidSelectAdd()
            delegate?.iceCreamsViewControllerDidSelectAdd()
        case .iceCream(let iceCream):
            //iceCreamsViewControllerDidSelectIceCream(iceCream)
            delegate?.iceCreamsViewControllerDidSelectIceCream(iceCream)
        }
    }
    
    // MARK: Convenience
    
    private func dequeueIceCreamCell(for iceCream: IceCream, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: IceCreamCell.reuseIdentifier, for: indexPath) as? IceCreamCell
            else { fatalError("Unable to dequeue am IceCreamCell") }
        
        cell.representedIceCream = iceCream
        
        // Use a placeholder sticker while we fetch the real one from the cache.
        let cache = IceCreamStickerCache.cache
        cell.stickerView.sticker = cache.placeholderSticker
        
        // Fetch the sticker for the ice cream from the cache.
        cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                guard cell.representedIceCream == iceCream else { return }
                cell.stickerView.sticker = sticker
            }
        }
        
        return cell
    }
    
    private func dequeueIceCreamAddCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: IceCreamAddCell.reuseIdentifier,
                                                             for: indexPath) as? IceCreamAddCell
            else { fatalError("Unable to dequeue a IceCreamAddCell") }
        return cell
    }
}

//extension IceCreamsViewController: BuildIceCreamViewControllerDelegate {
//    
//    /// - Tag: ComposeMessage
//    fileprivate func composeMessage(with iceCream: IceCream, caption: String, session: MSSession? = nil) -> MSMessage {
//        var components = URLComponents()
//        components.queryItems = iceCream.queryItems
//        
//        let layout = MSMessageTemplateLayout()
//        layout.image = iceCream.renderSticker(opaque: true)
//        layout.caption = caption
//        
//        let message = MSMessage(session: session ?? MSSession())
//        message.url = components.url!
//        message.layout = layout
//        
//        return message
//    }
//
//    /// - Tag: InsertMessageInConversation
//    func buildIceCreamViewController(_ controller: BuildIceCreamViewController, didSelect iceCreamPart: IceCreamPart) {
////        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
//        guard var iceCream = controller.iceCream else { fatalError("Expected the controller to be displaying an ice cream") }
//
//        // Update the ice cream with the selected body part and determine a caption and description of the change.
//        var messageCaption: String
//        if let base = iceCreamPart as? Base {
//            iceCream.base = base
//            messageCaption = NSLocalizedString("Let's build an ice cream", comment: "")
//        } else if let scoops = iceCreamPart as? Scoops {
//            iceCream.scoops = scoops
//            messageCaption = NSLocalizedString("I added some scoops", comment: "")
//        } else if let topping = iceCreamPart as? Topping {
//            iceCream.topping = topping
//            messageCaption = NSLocalizedString("Our finished ice cream", comment: "")
//        } else {
//            fatalError("Unexpected type of ice cream part selected.")
//        }
//
//        // Create a new message with the same session as any currently selected message.
//        let message = composeMessage(with: iceCream, caption: messageCaption, session: nil)
//
//        
//        
//        // Add the message to the conversation.
////        conversation.insert(message) { error in
////            if let error = error {
////                print(error)
////            }
////        }
//
//        // If the ice cream is complete, save it in the history.
//        if iceCream.isComplete {
//            var history = IceCreamHistory.load()
//            history.append(iceCream)
//            history.save()
//            self.navigationController?.popViewController(animated: true)
//        } else {
////            self.navigationController?.popViewController(animated: true)
////            self.presentViewController(iceCream: iceCream)
//            controller.iceCream = iceCream
//            controller.reload()
//        }
//        
//        //dismiss()
//    }
//}


// A delegate protocol for the `IceCreamsViewController` class

protocol IceCreamsViewControllerDelegate: AnyObject {

    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.

    func iceCreamsViewControllerDidSelectAdd()
    func iceCreamsViewControllerDidSelectIceCream(_ iceCream: IceCream)
}

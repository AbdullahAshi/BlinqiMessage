/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view controller shown to select an ice-cream part for a partially built ice cream.
*/

import UIKit

/// A delegate protocol for the `BuildIceCreamViewController` class.

protocol BuildIceCreamViewControllerDelegate: AnyObject {
    func doneAddingIceCream()
}

class BuildIceCreamViewController: UIViewController {

    // MARK: Properties

    static let storyboardIdentifier = "BuildIceCreamViewController"
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var iceCreamView: IceCreamView!
    @IBOutlet weak var iceCreamViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: BuildIceCreamViewControllerDelegate?
    var viewModel: BuildIceCreamViewModel!
    
    var iceCream: IceCream? {
        return viewModel.iceCream
    }
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }
    
    func reload() {
        guard isViewLoaded else { return }
        // Make sure the prompt and ice cream view are showing the correct information.
        promptLabel.text = viewModel.prompt
        iceCreamView.iceCream = viewModel.iceCream
        
        // We want the collection view to decelerate faster than normal so comes to rest on a body part more quickly.
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // There is nothing to layout of there are no ice cream parts to pick from.
        guard !viewModel.iceCreamParts.isEmpty else { return }
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else { fatalError("Expected the collection view to have a UICollectionViewFlowLayout") }
        
        // The ideal cell width is 1/3 of the width of the collection view.
        layout.itemSize.width = floor(view.bounds.size.width / 3.0)

        // Set the cell height using the aspect ratio of the ice cream part images.
        let iceCreamPartImageSize = viewModel.iceCreamParts[0].image.size
        guard iceCreamPartImageSize.width > 0 else { return }
        let imageAspectRatio = iceCreamPartImageSize.width / iceCreamPartImageSize.height
        
        layout.itemSize.height = floor(layout.itemSize.width / imageAspectRatio)
        
        // Set the collection view's height constraint to match the cell size.
        collectionViewHeightConstraint.constant = layout.itemSize.height
        
        // Adjust the collection view's `contentInset` so the first item is centered.
        var contentInset = collectionView.contentInset
        contentInset.left = (view.bounds.size.width - layout.itemSize.width) / 2.0
        contentInset.right = contentInset.left
        collectionView.contentInset = contentInset
        
        // Calculate the ideal height of the ice cream view.
        let iceCreamViewContentHeight = iceCreamView.arrangedSubviews.reduce(0.0) { total, arrangedSubview in
            return total + arrangedSubview.intrinsicContentSize.height
        }
        
        let iceCreamPartImageScale = layout.itemSize.height / iceCreamPartImageSize.height
        iceCreamViewHeightConstraint.constant = floor(iceCreamViewContentHeight * iceCreamPartImageScale)
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func didTapSelect(_: AnyObject) {
        // Determine the index path of the centered cell in the collection view.
        guard let layout = collectionView.collectionViewLayout as? IceCreamPartCollectionViewLayout
            else { fatalError("Expected the collection view to have a IceCreamPartCollectionViewLayout") }
        
        let halfWidth = collectionView.bounds.size.width / 2.0
        guard let indexPath = layout.indexPathForVisibleItemClosest(to: collectionView.contentOffset.x + halfWidth) else { return }
        
        guard let iceCream = iceCream else { return }
        
        let isComplete = viewModel.didSelectPartAndNotifyIfFinished(at: indexPath.row, for: iceCream)
        
        if isComplete {
            delegate?.doneAddingIceCream()
        } else {
            reload()
        }
    }
}

/// Extends `BuildIceCreamViewController` to conform to the `UICollectionViewDataSource` protocol.

extension BuildIceCreamViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.iceCreamParts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IceCreamPartCell.reuseIdentifier,
                                                            for: indexPath as IndexPath) as? IceCreamPartCell
            else { fatalError("Unable to dequeue a BodyPartCell") }

        let iceCreamPart = viewModel.iceCreamParts[indexPath.row]
        cell.imageView.image = iceCreamPart.image
        
        return cell
    }

}

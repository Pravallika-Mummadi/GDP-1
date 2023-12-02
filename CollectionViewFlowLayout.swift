

import Foundation
import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        configureLayout()
    }

    private func configureLayout() {
        guard let collectionView = collectionView else { return }

        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let itemWidth = (availableWidth - minimumInteritemSpacing) / 2

        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
}

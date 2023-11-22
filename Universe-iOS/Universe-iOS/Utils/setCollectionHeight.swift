//
//  setCollectionHeight.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/14.
//

import UIKit
import SnapKit

extension UIViewController {
    func setCollectionHeight(collectionView: UICollectionView) {
        collectionView.layoutIfNeeded()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionView.contentSize.height)
        }
    }
    
    func setCollectionHeightWithBottomInset(collectionView: UICollectionView, bottomInset: Double) {
        collectionView.layoutIfNeeded()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionView.contentSize.height + bottomInset)
        }
    }
}

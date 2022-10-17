//
//  SliderContainableCollectionView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 23.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class SliderContainableCollectionView: UICollectionView {

    // MARK: - Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Overrides
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return !(view is UISlider)
    }

    // MARK: - Private
    private func initialize() {
        canCancelContentTouches = true
        delaysContentTouches = false
    }
}

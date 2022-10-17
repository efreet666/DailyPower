//
//  UIView+EmbedSubview.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

extension UIView {

    struct EmbedEdgeInsets {

        let top: CGFloat?
        let left: CGFloat?
        let bottom: CGFloat?
        let right: CGFloat?
    }

    func embedSubview(_ view: UIView, edgeInsets: EmbedEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)

        let constraints = [
            edgeInsets.top.map { view.topAnchor.constraint(equalTo: topAnchor, constant: $0) },
            edgeInsets.left.map { view.leftAnchor.constraint(equalTo: leftAnchor, constant: $0) },
            edgeInsets.bottom.map { view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -$0) },
            edgeInsets.right.map { view.rightAnchor.constraint(equalTo: rightAnchor, constant: -$0) }
        ]

        NSLayoutConstraint.activate(constraints.compactMap { $0 })
    }
}

extension UIView.EmbedEdgeInsets {

    init(edgeInsets: UIEdgeInsets) {
        self.top = edgeInsets.top
        self.left = edgeInsets.left
        self.bottom = edgeInsets.bottom
        self.right = edgeInsets.right
    }

    static let zero = UIView.EmbedEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}

//
//  PlayerEmbedderTarget.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum PlayerEmbedderTarget<Identifier: Equatable> {

    // Usual static views, UITableView.header/.footer views, etc.
    case `static`

    // UITableView/UICollectionView.section.header/.footer, UITableView/UICollectionView.cell, etc.
    case `dynamic`(Identifier)
}

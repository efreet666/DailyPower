//
//  ContainerProvider.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 04.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import XCoordinator

protocol ContainerProvider {

    associatedtype EmbedTarget

    func container(for target: EmbedTarget) -> Container
}

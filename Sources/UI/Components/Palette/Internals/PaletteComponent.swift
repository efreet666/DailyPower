//
//  PaletteComponent.swift
//  DailyPower
//
//  Created by Michael Krasnenkov on 14.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

protocol PaletteComponent {

    associatedtype Key: RawRepresentable where Key.RawValue == String
    associatedtype Value

    func value(for key: Key) -> Value
}

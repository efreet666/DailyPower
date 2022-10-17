//
//  PlayerEngine.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol PlayerEngine: class {

    // вью видеовыхода
    var surfaceView: UIView { get }

    // режим масштабирования видео
    var scaleMode: Binder<PlayerScaleMode> { get }

    // текущая позиция воспроизведения
    var itemPosition: Observable<PlayerTime> { get }

    // длительность контента
    var itemDuration: Observable<PlayerTime> { get }

    // состояние движка
    var engineState: Observable<PlayerEngineState> { get }

    // состояние воспроизведения
    var playbackState: Observable<PlayerPlaybackState> { get }

    // контентный урл
    var url: Observable<URL?> { get }

    // сигнал окончания воспроизведения текущего контента
    var playbackFinished: Observable<Void> { get }

    // проинициализироватся урлом, перемотать если указан time, начать воспроизведение если не initiallyPaused
    func open(url: URL, at time: TimeInterval?, initiallyPaused: Bool)

    // снять с паузы
    func play()

    // поставить на паузу
    func pause()

    // перемотать на определенное время
    func seek(to time: TimeInterval)
}

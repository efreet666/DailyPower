//
//  UITableView+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 17.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITableView {

    typealias HeaderFooterViewDisplayingEvent = (view: UIView, section: Int)

    var willDisplayHeaderView: ControlEvent<HeaderFooterViewDisplayingEvent> {
        return headerFooterViewDisplayingEvent(for: #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:)))
    }

    var willDisplayFooterView: ControlEvent<HeaderFooterViewDisplayingEvent> {
        return headerFooterViewDisplayingEvent(for: #selector(UITableViewDelegate.tableView(_:willDisplayFooterView:forSection:)))
    }

    var didEndDisplayingHeaderView: ControlEvent<HeaderFooterViewDisplayingEvent> {
        return headerFooterViewDisplayingEvent(for: #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:)))
    }

    var didEndDisplayingFooterView: ControlEvent<HeaderFooterViewDisplayingEvent> {
        return headerFooterViewDisplayingEvent(for: #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:)))
    }

    private func headerFooterViewDisplayingEvent(for selector: Selector) -> ControlEvent<HeaderFooterViewDisplayingEvent> {
        let source = delegate.methodInvoked(selector).compactMap { arguments -> HeaderFooterViewDisplayingEvent? in
            guard arguments.count > 2, let view = arguments[1] as? UIView, let section = arguments[2] as? Int else {
                return nil
            }
            return (view, section)
        }
        return ControlEvent(events: source)
    }
}

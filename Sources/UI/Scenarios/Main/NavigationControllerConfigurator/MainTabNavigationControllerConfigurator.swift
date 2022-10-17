//
//  MainTabNavigationControllerConfigurator.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 12.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import UIKit

final class MainTabNavigationControllerConfigurator {

    // MARK: - Dependencies
    lazy var tab: MainTab = deferred()

    // MARK: - Public
    func configure(navigationController: UINavigationController) {
        navigationController.tabBarItem = with(UITabBarItem()) {
            $0.title = tab.title
            $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
            $0.image = tab.image
            $0.selectedImage = tab.selectedImage
            $0.imageInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0)
        }
    }
}

private extension MainTab {

    var title: String {
        switch self {
        case .planner:
            return R.string.localizable.main_tabbar_planner()
        case .nutrition:
            return R.string.localizable.main_tabbar_nutrition()
        case .workouts:
            return R.string.localizable.main_tabbar_workouts()
        case .motivation:
            return R.string.localizable.main_tabbar_motivation()
        case .profile:
            return R.string.localizable.main_tabbar_profile()
        }
    }

    var image: UIImage? {
        switch self {
        case .planner:
            return R.image.mainTabbar.planner()
        case .nutrition:
            return R.image.mainTabbar.nutrition()
        case .workouts:
            return R.image.mainTabbar.workouts()
        case .motivation:
            return R.image.mainTabbar.motivation()
        case .profile:
            return R.image.mainTabbar.profile()
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .planner:
            return R.image.mainTabbar.planner_selected()
        case .nutrition:
            return R.image.mainTabbar.nutrition_selected()
        case .workouts:
            return R.image.mainTabbar.workouts_selected()
        case .motivation:
            return R.image.mainTabbar.motivation_selected()
        case .profile:
            return R.image.mainTabbar.profile_selected()
        }
    }
}

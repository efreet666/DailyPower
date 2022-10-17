//
//  SystemInfo.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import UIKit

final class SystemInfo {

    // MARK: - Public
    var appVersion: String {
        guard let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            assertionFailure("Info.plist has no 'app version' field")
            return ""
        }
        return value
    }

    var appBundleVersion: String {
        guard let value = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            assertionFailure("Info.plist has no 'app bundle version' field")
            return ""
        }
        return value
    }

    var osVersion: String {
        return UIDevice.current.systemVersion
    }

    var vcsBranchName: String {
        guard let url = Bundle.main.url(forResource: "BuildInfo", withExtension: "plist") else {
            assertionFailure("BuildInfo.plist file missing")
            return ""
        }
        guard let buildInfo = NSDictionary(contentsOf: url) as? [String: Any] else {
            assertionFailure("Can't load BuildInfo.plist")
            return ""
        }
        guard let value = buildInfo["BuildInfoGitBranch"] as? String else {
            assertionFailure("BuildInfo.plist has no 'git branch' field")
            return ""
        }
        return value
    }

    var vcsCommitSHA: String {
        guard let url = Bundle.main.url(forResource: "BuildInfo", withExtension: "plist") else {
            assertionFailure("BuildInfo.plist file missing")
            return ""
        }
        guard let buildInfo = NSDictionary(contentsOf: url) as? [String: Any] else {
            assertionFailure("Can't load BuildInfo.plist")
            return ""
        }
        guard let value = buildInfo["BuildInfoGitCommit"] as? String else {
            assertionFailure("BuildInfo.plist has no 'git commit' field")
            return ""
        }
        return value
    }

    var appBundleIdentifier: String {
        guard let value = Bundle.main.bundleIdentifier else {
            assertionFailure("Unable to get app bundle identifier")
            return ""
        }
        return value
    }

    var identifierForVendor: UUID {
        guard let value = UIDevice.current.identifierForVendor else {
            assertionFailure("Unable to get identifier for vendor")
            return UUID()
        }
        return value
    }
}

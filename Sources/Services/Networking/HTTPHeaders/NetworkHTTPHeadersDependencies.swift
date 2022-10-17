//
//  NetworkHTTPHeadersDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol NetworkHTTPHeadersAuthDataProvider {

    var accessToken: Single<String?> { get }
}

protocol NetworkHTTPHeadersSystemInfoProvider {

    var appVersion: String { get }
}

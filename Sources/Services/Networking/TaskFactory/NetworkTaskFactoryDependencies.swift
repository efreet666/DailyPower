//
//  NetworkTaskFactoryDependencies.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

protocol NetworkTaskFactoryHTTPHeadersProvider {

    func headers(for request: NetworkRequest) -> Single<[String: String]>
}

protocol NetworkTaskFactoryAPIBaseURLProvider {

    func apiBaseURL(for request: NetworkRequest) -> Single<URL>
}

protocol NetworkTaskFactorySessionManager {

    func generalTask(url: URL,
                     method: NetworkRequestHTTPMethod,
                     parameters: [String: Any]?,
                     parametersEncoding: NetworkRequestParametersEncoding,
                     headers: [String: String]) -> Single<NetworkTask>

    func uploadTask(url: URL,
                    method: NetworkRequestHTTPMethod,
                    data: Data,
                    headers: [String: String]) -> Single<NetworkTask>

    // swiftlint:disable:next function_parameter_count
    func multipartTask(url: URL,
                       method: NetworkRequestHTTPMethod,
                       data: Data,
                       name: String,
                       mimeType: String,
                       headers: [String: String]) -> Single<NetworkTask>
}

//
//  NetworkTaskFactory.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkTaskFactory {

    // MARK: - Dependencies
    lazy var httpHeadersProvider: NetworkTaskFactoryHTTPHeadersProvider = deferred()
    lazy var apiBaseURLProvider: NetworkTaskFactoryAPIBaseURLProvider = deferred()
    lazy var sessionManager: NetworkTaskFactorySessionManager = deferred()

    // MARK: - Public
    func task(for networkRequest: NetworkRequest) -> Single<NetworkTask> {
        let url = createURL(for: networkRequest)
        let headers = httpHeadersProvider.headers(for: networkRequest)

        return Single.combineLatest(url, headers).flatMap {
            let (url, headers) = $0

            switch networkRequest.taskParameters {
            case let .general(parameters, parametersEncoding):
                return self.sessionManager.generalTask(
                    url: url,
                    method: networkRequest.httpMethod,
                    parameters: parameters,
                    parametersEncoding: parametersEncoding,
                    headers: headers
                )
            case let .upload(data):
                return self.sessionManager.uploadTask(
                    url: url,
                    method: networkRequest.httpMethod,
                    data: data,
                    headers: headers
                )
            case let .multipart(data, name, mimeType):
                return self.sessionManager.multipartTask(
                    url: url,
                    method: networkRequest.httpMethod,
                    data: data,
                    name: name,
                    mimeType: mimeType,
                    headers: headers
                )
            }
        }
    }

    // MARK: - Private
    func createURL(for networkRequest: NetworkRequest) -> Single<URL> {
        return apiBaseURLProvider.apiBaseURL(for: networkRequest).map { baseURL -> URL in
            var urlComponents: URLComponents

            switch networkRequest.path {
            case let .absolute(string):
                guard let components = URLComponents(string: string) else {
                    fatalError("Unable to get url components from absolute path: \(string)")
                }
                urlComponents = components
            case let .relative(string):
                guard let components = URLComponents(url: baseURL.appendingPathComponent(string), resolvingAgainstBaseURL: false) else {
                    fatalError("Unable to get url components from base url: \(baseURL) and relative path: \(string)")
                }
                urlComponents = components
            }

            let requestQueryItems = networkRequest.queryParameters.map(URLQueryItem.init)
            let queryItems = urlComponents.queryItems ?? [] + requestQueryItems

            urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems

            guard let url = urlComponents.url else {
                fatalError("Unable to get url from components: \(urlComponents)")
            }

            return url
        }
    }
}

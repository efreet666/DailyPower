//
//  NetworkRequest.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 07.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

enum NetworkRequestHTTPMethod: String {

    case get
    case post
    case put
    case patch
    case delete
}

enum NetworkRequestParametersEncoding {

    /// Encodes in query/body depending on http method with
    /// content type `application/x-www-form-urlencoded`
    case `default`

    /// Encodes in body with content type `application/json`
    case json
}

enum NetworkRequestAuthenticationType {

    case none
    case token
}

enum NetworkRequestPath {

    case absolute(String)
    case relative(String)
}

enum NetworkRequestTaskParameters {

    case general(parameters: [String: Any]?, parametersEncoding: NetworkRequestParametersEncoding)
    case upload(data: Data)
    case multipart(data: Data, name: String, mimeType: String)
}

protocol NetworkRequest: CustomStringConvertible {

    var httpMethod: NetworkRequestHTTPMethod { get }

    var path: NetworkRequestPath { get }

    /// Parameters to be encoded into query
    var queryParameters: [String: String?] { get }

    /// Request-specific headers
    var httpHeaders: [String: String] { get }

    var requiredAuthentication: NetworkRequestAuthenticationType { get }

    var taskParameters: NetworkRequestTaskParameters { get }
}

extension NetworkRequest {

    var queryParameters: [String: String?] {
        return [:]
    }

    var httpHeaders: [String: String] {
        return [:]
    }

    var description: String {
        var urlComponents: URLComponents?

        switch path {
        case let .absolute(string):
            urlComponents = URLComponents(string: string)
        case let .relative(string):
            urlComponents = URLComponents()
            urlComponents?.path = string
        }

        let requestQueryItems = queryParameters.map(URLQueryItem.init)
        let queryItems = urlComponents?.queryItems ?? [] + requestQueryItems

        urlComponents?.queryItems = queryItems.isEmpty ? nil : queryItems

        let prefix = "\(httpMethod.rawValue.uppercased()) \(urlComponents?.string ?? "<INVALID URL>")"

        switch taskParameters {
        case .general(nil, _):
            return "\(prefix)"
        case let .general(parameters?, _):
            return "\(prefix) [\n\(parameters.map({ "\($0): \($1)" }).joined(separator: "\n"))\n]"
        case let .upload(data):
            return "\(prefix) [\n...\(data.count) bytes of raw data...\n]"
        case let .multipart(data, name, mimeType):
            return "\(prefix) [\n...\(data.count) bytes of multipart data with name '\(name)' MIME type '\(mimeType)'...\n]"
        }
    }
}

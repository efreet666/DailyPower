//
//  NetworkTaskFactoryDependenciesExtensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 08.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Alamofire
import MobileCoreServices
import RxSwift

extension NetworkHTTPHeaders: NetworkTaskFactoryHTTPHeadersProvider {
}

struct NetworkTaskFactoryAppSettingsAPIBaseURLProvider: NetworkTaskFactoryAPIBaseURLProvider {

    let appSettings: AppSettings

    func apiBaseURL(for request: NetworkRequest) -> Single<URL> {
        return appSettings.apiBaseURLObservable.take(1).asSingle()
    }
}

struct NetworkTaskFactoryAlamofireSessionManager: NetworkTaskFactorySessionManager {

    let sessionManager: SessionManager

    func generalTask(url: URL,
                     method: NetworkRequestHTTPMethod,
                     parameters: [String: Any]?,
                     parametersEncoding: NetworkRequestParametersEncoding,
                     headers: [String: String]) -> Single<NetworkTask> {

        return Single.create { observer in
            let request = self.sessionManager.request(
                url,
                method: method.alamofireEntity,
                parameters: parameters,
                encoding: parametersEncoding.alamofireEntity,
                headers: headers
            )
            observer(.success(AlamofireTask(request: request)))

            return Disposables.create()
        }
    }

    func uploadTask(url: URL,
                    method: NetworkRequestHTTPMethod,
                    data: Data,
                    headers: [String: String]) -> Single<NetworkTask> {

        return Single.create { observer in
            let request = self.sessionManager.upload(
                data,
                to: url,
                method: method.alamofireEntity,
                headers: headers
            )
            observer(.success(AlamofireTask(request: request)))

            return Disposables.create()
        }
    }

    // swiftlint:disable:next function_parameter_count
    func multipartTask(url: URL,
                       method: NetworkRequestHTTPMethod,
                       data: Data,
                       name: String,
                       mimeType: String,
                       headers: [String: String]) -> Single<NetworkTask> {

        return Single.create { observer in
            self.sessionManager.upload(
                multipartFormData: { multipartFormData in
                    let fileName = MIMETypeHelper.fileName(withName: name, mimeType: mimeType)
                    multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                },
                to: url,
                method: method.alamofireEntity,
                headers: headers,
                encodingCompletion: { result in
                    switch result {
                    case let .success(request, _, _):
                        observer(.success(AlamofireTask(request: request)))
                    case let .failure(error):
                        observer(.error(AFErrorHelper.wrappedError(error)))
                    }
                }
            )

            return Disposables.create()
        }
    }
}

private extension NetworkRequestHTTPMethod {

    var alamofireEntity: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
}

private extension NetworkRequestParametersEncoding {

    var alamofireEntity: ParameterEncoding {
        switch self {
        case .default:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }
}

private struct AlamofireTask<Request: DataRequest>: NetworkTask {

    let request: Request

    func responseJSON(queue: DispatchQueue = DispatchQueue.main, completionHandler: @escaping NetworkResponseCompletion) -> AlamofireTask {
        request.validate().responseJSON(queue: queue) { dataResponse in
            let data = dataResponse.result.isSuccess ? dataResponse.value : dataResponse.data
            completionHandler(data, dataResponse.error.map(AFErrorHelper.wrappedError), dataResponse.timeline)
        }
        return self
    }

    func responseEmpty(queue: DispatchQueue = DispatchQueue.main, completionHandler: @escaping NetworkResponseCompletion) -> AlamofireTask {
        request.validate().response(queue: queue) { dataResponse in
            completionHandler(dataResponse.data, dataResponse.error.map(AFErrorHelper.wrappedError), dataResponse.timeline)
        }
        return self
    }

    func responseData(queue: DispatchQueue = DispatchQueue.main, completionHandler: @escaping NetworkResponseCompletion) -> AlamofireTask {
        request.validate().responseData(queue: queue) { dataResponse in
            let data = dataResponse.result.isSuccess ? dataResponse.value : dataResponse.data
            completionHandler(data, dataResponse.error.map(AFErrorHelper.wrappedError), dataResponse.timeline)
        }
        return self
    }

    func resume() {
        request.resume()
    }

    func suspend() {
        request.suspend()
    }

    func cancel() {
        request.cancel()
    }
}

extension Timeline: NetworkRequestTimeline {
}

private enum AFErrorHelper {

    static func wrappedError(_ error: Error) -> Error {
        guard let alamofireError = error as? AFError else {
            return error
        }

        switch alamofireError {
        case .invalidURL:
            return NetworkError(.invalidURL, underlyingError: alamofireError)
        case .parameterEncodingFailed, .multipartEncodingFailed:
            return NetworkError(.cannotEncodeRequest, underlyingError: alamofireError)
        case .responseValidationFailed:
            return NetworkError(.unacceptableResponse, underlyingError: alamofireError)
        case .responseSerializationFailed:
            return NetworkError(.cannotSerializeResponse, underlyingError: alamofireError)
        }
    }
}

private enum MIMETypeHelper {

    static func pathExtension(forMIMEType mimeType: String) -> String? {
        guard let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return nil
        }
        guard let extensionUTI = UTTypeCopyPreferredTagWithClass(mimeUTI, kUTTagClassFilenameExtension)?.takeRetainedValue() else {
            return nil
        }
        return extensionUTI as String
    }

    static func fileName(withName name: String, mimeType: String) -> String {
        return [name, pathExtension(forMIMEType: mimeType)].compactMap({ $0 }).joined(separator: ".")
    }
}

//
//  NetworkResponse+Rx.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 11.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import RxSwift

extension ObservableType {

    func payload<T>() -> Observable<T> where Element == DecodableNetworkResponse<T> {
        return map { $0.payload }
    }

    func payload<T>() -> Observable<T> where Element == JSONNetworkResponse<T> {
        return map { $0.payload }
    }
}

extension ObservableType where Element == DataNetworkResponse {

    func payload() -> Observable<Data> {
        return map { $0.payload }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {

    func payload<T>() -> Single<T> where Element == DecodableNetworkResponse<T> {
        return map { $0.payload }
    }

    func payload<T>() -> Single<T> where Element == JSONNetworkResponse<T> {
        return map { $0.payload }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait, Element == DataNetworkResponse {

    func payload() -> Single<Data> {
        return map { $0.payload }
    }
}

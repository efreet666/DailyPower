//
//  ErrorAlertContentFactory.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 22.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

final class ErrorAlertContentFactory {

    // MARK: - Public
    func alertContent(for error: Error) -> AlertContent {
        let message = contentMessage(for: error)
        let buttons = contentButtons(for: error)

        return AlertContent(title: R.string.localizable.alert_title_error(), message: message, buttons: buttons)
    }

    // MARK: - Private
    private func contentMessage(for error: Error) -> String {
        switch error {
        case let error as UIError:
            return message(for: error)
        case let error as NetworkError:
            return message(for: error)
        case let error as URLError:
            return message(for: error)
        case let error as AuthServiceError:
            return message(for: error)
        case let error as DataValidationError:
            return message(for: error)
        default:
            return error.localizedDescription
        }
    }

    private func message(for error: UIError) -> String {
        switch error.code {
        case .internalInconsistency:
            return R.string.localizable.error_message_unknown_internal_error()
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func message(for error: NetworkError) -> String {
        switch error.code {
        case .noAccessToken:
            return R.string.localizable.error_message_request_failed_no_token()
        case .cannotMapResponse, .cannotSerializeResponse:
            return R.string.localizable.error_message_response_mapping_error()
        case .invalidURL, .cannotEncodeRequest:
            return R.string.localizable.error_message_cannot_build_request()
        case .unacceptableResponse:
            return R.string.localizable.error_message_request_failed()
        case let .serverError(payload):
            switch payload.code {
            case .internalInconsistency:
                return R.string.localizable.error_message_internal_server_error()
            case .invalidParameters:
                return R.string.localizable.error_message_invalid_parameters()
            case .userNotFound:
                return R.string.localizable.error_message_user_not_found()
            case .userAlreadyExists:
                return R.string.localizable.error_message_user_already_exists()
            case .badCredentials:
                return R.string.localizable.error_message_bad_credentials()
            case .invalidToken:
                return R.string.localizable.error_message_invalid_token()
            case .tokenExpired:
                return R.string.localizable.error_message_token_expired()
            case let .unknown(value):
                return R.string.localizable.error_message_unknown_server_error(value)
            }
        }
    }

    private func message(for error: URLError) -> String {
        switch error.code {
        case .secureConnectionFailed, .serverCertificateUntrusted, .clientCertificateRejected:
            return R.string.localizable.error_message_server_insecure_connection()
        case .cannotFindHost, .cannotConnectToHost:
            return R.string.localizable.error_message_server_unavailable()
        case .notConnectedToInternet, .networkConnectionLost:
            return R.string.localizable.error_message_no_internet()
        default:
            return R.string.localizable.error_message_request_failed()
        }
    }

    private func message(for error: AuthServiceError) -> String {
        switch error.code {
        case .noRefreshToken:
            return R.string.localizable.error_message_request_failed_no_token()
        }
    }

    private func message(for error: DataValidationError) -> String {
        switch (error.code, error.dataType) {
        case (.unknown, _):
            return R.string.localizable.error_message_unknown_validation_error()
        case (.format, .email):
            return R.string.localizable.error_message_wrong_email_format()
        case (.format, .password):
            return R.string.localizable.error_message_wrong_password_format()
        case (.format, .generic):
            return R.string.localizable.error_message_wrong_data_format()
        case (.length, .email):
            return R.string.localizable.error_message_wrong_email_length()
        case (.length, .password):
            return R.string.localizable.error_message_wrong_password_length()
        case (.length, .generic):
            return R.string.localizable.error_message_wrong_data_length()
        }
    }

    private func contentButtons(for error: Error) -> [AlertContent.Button] {
        switch error {
        case is DataValidationError:
            return [.okay]
        default:
            return [.cancel, .retry]
        }
    }
}

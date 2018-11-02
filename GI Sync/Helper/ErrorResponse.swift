//
//  ErrorResponse.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import Alamofire

class ErrorResponse {
    static func handleErrorResponse<T>(response: DataResponse<T>, failed: @escaping (_ error: Error) -> Void) {
        if let responseText = String(data: response.data!, encoding: String.Encoding.utf8) {
            log.error(responseText)
        }

        if let statusCode = response.response?.statusCode {
            let error = NSError(domain: "", code: statusCode, userInfo: nil)
            failed(error as Error)
        } else {
            log.error("Request failed, unknown statusCode")
        }
    }
}

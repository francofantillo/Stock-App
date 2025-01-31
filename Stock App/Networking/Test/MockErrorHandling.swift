//
//  MockErrorHandling.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-31.
//

import Foundation

class MockErrorHandling: ErrorHandling {
    var didHandleError = false
    
    override func handle(error: any Error) {
        didHandleError = true
    }
    
    override func handleApiError(error: APIErrors) {
        didHandleError = true
    }

    override func handleErrorWithToast(error: any Error) {
        didHandleError = true
    }
    
    override func handleAPIErrorWithToast(error: APIErrors) {
        didHandleError = true
    }
}

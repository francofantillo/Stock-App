//
//  ErrorHandling.swift
//  Stock App
//
//  Created by Franco Fantillo on 2025-01-28.
//

import AlertToast

import SwiftUI

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}

// For global error handling
extension View {
    func withErrorHandling() -> some View {
        modifier(HandleErrorsByShowingAlertViewModifier())
    }
}

class ErrorHandling: ObservableObject {
    
    @Published var currentAlert: ErrorAlert?
    @Published var showToast: Bool = false
    @Published var errorMessage = "Error"

    @MainActor
    func handleApiError(error: APIErrors) {
        self.currentAlert = ErrorAlert(message: error.errorDescription ?? "Unknown error.")
    }
    
    @MainActor
    func handle(error: Error) {
        self.currentAlert = ErrorAlert(message: error.localizedDescription)
    }
    
    @MainActor
    func handleAPIErrorWithToast(error: APIErrors) {
        errorMessage = error.errorDescription ?? "Unknown error."
        showToast = true
    }
    
    @MainActor
    func handleErrorWithToast(error: Error) {
        errorMessage = error.localizedDescription
        showToast = true
    }
}

struct HandleErrorsByShowingAlertViewModifier: ViewModifier {
    @EnvironmentObject var errorHandling: ErrorHandling

    func body(content: Content) -> some View {
        content
            .alert(item: $errorHandling.currentAlert) { currentAlert in
                Alert(
                    title: Text("Error"),
                    message: Text(currentAlert.message),
                    dismissButton: .default(Text("Ok")) {
                        currentAlert.dismissAction?()
                    }
                )
            }
            .toast(isPresenting: $errorHandling.showToast, duration: 2) {
                AlertToast(displayMode: .banner(.pop), type: .regular, title: "Error", subTitle: errorHandling.errorMessage)
            }
    }
}

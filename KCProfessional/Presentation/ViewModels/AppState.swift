import Foundation

enum LoginStatus {
    case none
    case success
    case error
    case notValidated
}

final class AppState {
    @Published var loginStatus: LoginStatus = .none
    
    //Dependencies
    private var loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase = DefaultLoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func loginApp(user: String, pass: String) {
        Task {
            if await loginUseCase.login(user: user, password: pass) {
                self.loginStatus = .success
            } else {
                self.loginStatus = .error
            }
        }
    }
    
    func validateLogin() {
        Task {
            if await loginUseCase.validateToken() {
                self.loginStatus = .success
            } else {
                self.loginStatus = .notValidated
            }
        }
    }
    
    func closeSessionUser() {
        Task {
            await loginUseCase.logout()
            self.loginStatus = .none
        }
    }
}



import Foundation

final class DefaultLoginRepository: LoginRepositoryProtocol {
    
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol) {
        self.network = network
    }
    
    func loginApp(user: String, pass: String) async -> String {
        return await network.loginApp(user: user, password: pass)
    }
}

final class LoginRepositoryFake: LoginRepositoryProtocol {
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol = NetworkLoginFake()) {
        self.network = network
    }
     
    func loginApp(user: String, pass: String) async -> String {
        return await network.loginApp(user: user, password: pass)
    }
}

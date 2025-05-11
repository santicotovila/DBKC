import Foundation

protocol LoginRepositoryProtocol {
    func loginApp(user:String, pass:String) async -> String
}

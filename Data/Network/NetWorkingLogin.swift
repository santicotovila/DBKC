import Foundation

protocol NetworkLoginProtocol {
    func loginApp(user: String, password: String) async -> String //devuelve el token JWT
}

final class NetworkLogin: NetworkLoginProtocol {
    func loginApp(user: String, password: String) async -> String {
        var tokenJWT: String = ""
        
        let url: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.login.rawValue)"
        let encodeCredentials = "\(user):\(password)".data(using: .utf8)?.base64EncodedString()
        var segCredential: String = ""
        if let credentials = encodeCredentials {
            segCredential = "Basic \(credentials)"
        }
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        request.addValue(segCredential, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let resp = response as? HTTPURLResponse {
                print("la respuesta es \(resp)")
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    tokenJWT = String(decoding: data, as: UTF8.self) //Asignamos la respuesta al token
                }
                else {
                    print("se recibio \(resp.statusCode)")
                }
            }
        } catch {
            tokenJWT = ""
        }
        return tokenJWT
    }
}

final class NetworkLoginFake: NetworkLoginProtocol {
    func loginApp(user: String, password: String) async -> String {
        return UUID().uuidString
    }
}

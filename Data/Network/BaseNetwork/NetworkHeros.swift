import Foundation
import KCLibrarySwift

protocol NetworkHerosProtocol {
    func getHerosMock(filter: String) async -> [HerosEntity]
    func getTransformationsAPI(heroID: String) async -> [TransformationsEntity]
}


final class NetworkHeros: NetworkHerosProtocol{
    func getHerosMock(filter: String) async -> [HerosEntity] {
        var modelReturn = [HerosEntity]()
        
        let url : String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.heros.rawValue)"
        var request : URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(HeroModelRequest(name: filter))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
    
        //Token JWT (habría que extraer de aqui) a algo generico o interceptor
        let JwtToken =  KeychainManager.shared.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJWT = JwtToken{
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization") //Token
        }
        
        //Call to server
        
        do{
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let resp = response  as? HTTPURLResponse {
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    modelReturn = try! JSONDecoder().decode([HerosEntity].self, from: data)
                }
            }
            
        }catch{
            print("error:\(HTTPResponseCodes.ERROR)")
        }
        
        return modelReturn
    }
    
    func getTransformationsAPI(heroID: String) async -> [TransformationsEntity] {
        var modelReturn = [TransformationsEntity]()
        
        let url: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.transformations.rawValue)"
        var request : URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(TransformationsRequest(id: heroID))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        
        let JwtToken =  KeychainManager.shared.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJWT = JwtToken{
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization") //Token
        }
        
        // Call to server
        
        do {
            let (data,response) = try await URLSession.shared.data(for: request)
            print("datos recibidos \(data) y respuesta \(response)")
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    modelReturn = try! JSONDecoder().decode([TransformationsEntity].self, from: data)
                }
                print("la respuesta es \(resp)")
            }
        }
        catch {
            print("error:\(HTTPResponseCodes.ERROR)")
        }
        return modelReturn
        
    }
    
}

final class NetworkHerosMock: NetworkHerosProtocol{
    func getTransformationsAPI(heroID: String) async -> [TransformationsEntity] {
        return getTransformationsHardcoded()
    }
    
    func getHerosMock(filter: String) async -> [HerosEntity] {
        return getHerosHardcoded()
    }
    
    
    func getHerosFromJson() -> [HerosEntity] {
        if let url = Bundle.main.url(forResource: "heros", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([HerosEntity].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
    

    
    func getHerosHardcoded() -> [HerosEntity] {
        let model1 = HerosEntity(id: "",
                                 favorite: true,
                                 description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
                                 photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
                                 name: "Goku")
        
        let model2 = HerosEntity(id: "",
                                 favorite: true,
                                 description: "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.",
                                 photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300",
                                 name: "Vegeta")
        
        return [model1, model2]
    }
    
    
    func getTransformationsHardcoded() -> [TransformationsEntity] {
        let model1 = TransformationsEntity(photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
                                           description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru",
                                           id: "17824501-1106-4815-BC7A-BFDCCEE43CC9",
                                           name: "1. Oozaru – Gran Mono")
        
        let model2 = TransformationsEntity(photo:"https://areajugones.sport.es/wp-content/uploads/2017/05/Goku_Kaio-Ken_Coolers_Revenge.jpg",
                                           description:"La técnica de Kaio-sama permitía a Goku aumentar su poder de forma exponencial durante un breve periodo de tiempo para intentar realizar un ataque que acabe con el enemigo, ya que después de usar esta técnica a niveles altos el cuerpo de Kakarotto queda exhausto. Su máximo multiplicador de poder con esta técnica es de hasta x20, aunque en la película en la que se enfrenta contra Lord Slug es capaz de envolverse en éste aura roja a nivel x100" ,
                                           id: "9D6012A0-B6A9-4BAB-854D-67904E90CE01",
                                           name: "2. Kaio-Ken")
        
        return [model1,model2]
    }
}

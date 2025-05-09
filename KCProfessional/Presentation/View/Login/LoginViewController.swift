import UIKit
import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    
    //Objetos que quiero crear en la UI
    var logo: UIImageView!
    var loginButton: UIButton!
    var emailTextfield: UITextField!
    var passwordTexfield: UITextField!
    
    private var appState: AppState?
    
    init(appState: AppState) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //errorLabel.text = ""
        self.bindUI()
        loginButton.isEnabled = false
        emailTextfield.becomeFirstResponder() //Para que se enfoque nada mas entrar
    }
    
    override func loadView() {
        //Instancion la clase que va a generar la UI
        let loginView = LoginView()
        
        //Asigno las 2 cajas y el boton
        logo = loginView.logoImage
        emailTextfield = loginView.emailTextfield
        passwordTexfield = loginView.passwordTextfield
        loginButton = loginView.buttonLogin
        view = loginView
    }
    
    var suscriptions = Set<AnyCancellable>()
    
    private var password: String = ""
    private var user: String = ""
    
    
    // MARK: -  Private
    
    func bindUI() {
        suscribeUserText()
        suscribePassword()
        suscribeButton()
    }
    
    //Suscriptions
    
    private func suscribeUserText() {
        self.emailTextfield.textPublisher
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .compactMap{$0}
            .sink { [weak self] userText in
                print("User: \(userText)")
                self?.user = userText
                self?.enableButtonIfNeeded(userText)
            }
            .store(in: &suscriptions)
    }
    
    private func suscribePassword() {
        self.passwordTexfield.textPublisher
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] password in
                if let password {
                    print("Password: \(password)")
                    self?.password = password
                }
            }
            .store(in: &suscriptions)
    }
    
    private func suscribeButton() {
        self.loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if let user = self?.user,
                   let pass = self?.password,
                   pass.count > 0 {
                    self?.appState?.loginApp(user: user, pass: pass)
                } else {
                    print("No hacer nada")
                }
            }
            .store(in: &suscriptions)
    }
    
    // Validation
    
    private func enableButtonIfNeeded(_ userText: String) {
        self.loginButton.isEnabled = userText.count >= 5
    }
}

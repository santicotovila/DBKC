
import Foundation
import UIKit

final class LoginView: UIView {
    private enum Constants {
        static let textFieldHorizontalMargin: CGFloat = 50
    }
    
    //logo
    let logoImage = {
        let image = UIImageView(image: UIImage(named: "title"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let emailTextfield = {
        let textfield = UITextField()
        textfield.backgroundColor = .blue.withAlphaComponent(0.9)
        textfield.textColor = .white
        textfield.font = .systemFont(ofSize: 18)
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = NSLocalizedString("email", comment: "Email del usuario")
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.cornerRadius = 10
        textfield.layer.masksToBounds = true //Para que se vean las esquinas redondeadas
        // Color texto del placeholder
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textfield
    }()
    
    let passwordTextfield = {
        let textfield = UITextField()
        textfield.backgroundColor = .blue.withAlphaComponent(0.9)
        textfield.textColor = .white
        textfield.font = .systemFont(ofSize: 18)
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = NSLocalizedString("password", comment: "Password del usuario")
        textfield.layer.cornerRadius = 10
        textfield.layer.masksToBounds = true //Para que se vean las esquinas redondeadas
        // Color texto del placeholder
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textfield
    }()
    
    let buttonLogin = {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString("login", comment: "Password del usuario"),
            for: .normal
        )
        button.backgroundColor = .blue.withAlphaComponent(0.9)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Inicializadores
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        //añadimos los items de UI a la View
        let backgroundImage = UIImage(named: "fondo4")!
        backgroundColor = UIColor(patternImage: backgroundImage)
        addSubview(logoImage)
        addSubview(emailTextfield)
        addSubview(passwordTextfield)
        addSubview(buttonLogin)
        
        NSLayoutConstraint.activate([
            //Logo
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            logoImage.heightAnchor.constraint(equalToConstant: 50),
            
            //user
            emailTextfield.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            emailTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.textFieldHorizontalMargin),
            emailTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.textFieldHorizontalMargin),
            emailTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            //password
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 40),
            passwordTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.textFieldHorizontalMargin),
            passwordTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.textFieldHorizontalMargin),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            //boton login
            buttonLogin.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 75),
            buttonLogin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            buttonLogin.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            buttonLogin.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

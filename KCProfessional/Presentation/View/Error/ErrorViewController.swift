import UIKit
import Combine
import CombineCocoa

final class ErrorViewController: UIViewController {
    
    
    private var appState: AppState?
    private var suscriptors = Set<AnyCancellable>()
    private var errorString: String
    
    //MARK: - Outlets
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var buttonAlert: UIButton!
    
    
    init(appState: AppState? = nil, error: String) {
        self.appState = appState
        self.errorString = error
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.numberOfLines = 0
        self.errorLabel.text = self.errorString
        self.buttonAlert.setTitle(
            NSLocalizedString("error-button", comment: ""),
            for: .normal
        )
        
        self.buttonAlert.tapPublisher
            .sink{
                self.appState?.loginStatus = .none
            }
            .store(in: &suscriptors)
        
    }
}

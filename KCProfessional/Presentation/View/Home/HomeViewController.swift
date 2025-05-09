
import Foundation
import Combine
import UIKit

final class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var appState: AppState?
    private var viewModel: HerosViewModel
    var suscriptors = Set<AnyCancellable>()
    
    init(appState: AppState,viewModel: HerosViewModel = .init()) {
        self.appState = appState
        self.viewModel = viewModel
        super.init(nibName: "HomeView", bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Outlets
    
    @IBOutlet private weak var tableViewHeros: UITableView!
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("heros-title", comment: "")
        configViewModel()
        tableViewHeros.register(UINib(nibName: "HerosTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableViewHeros.delegate = self
        tableViewHeros.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cerrar",
            style: .plain,
            target: self,
            action: #selector(HomeViewController.closeSession)
        )
        
        
    }
    
    //MARK: - Sign Out

    @objc func closeSession() {
        self.appState?.closeSessionUser()
        
    }
    
    
    
}


extension HomeViewController {
   
    private func configViewModel() {
        self.viewModel.$heros
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableViewHeros.reloadData()
            }
            .store(in: &suscriptors)
        }
    
    func tableView(_ tableViewHeros: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.heros.count
    }
    
    func tableView(_ tableViewHeros: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hero = self.viewModel.heros[indexPath.row]
        guard let cell = tableViewHeros.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HerosTableViewCell else {return UITableViewCell()}
       
    
        cell.configure(with: hero)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableViewHeros: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = self.viewModel.heros[indexPath.row]
           
           let infoVM = HeroInfoViewModel()
           infoVM.selectedHero = hero
            
        let infoVC = HeroInfoViewController(viewModel: infoVM)
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func tableView(_ tableViewHeros: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
}

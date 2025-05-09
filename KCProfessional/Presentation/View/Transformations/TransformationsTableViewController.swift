import Combine
import UIKit
import Foundation

final class TransformationsTableViewController: UITableViewController {
    
   
    
    var viewModel: TransformationsViewModel = TransformationsViewModel()
    var suscriptors = Set<AnyCancellable>()
    
    init(viewModel: TransformationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationsView", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        configViewModel()
        self.title = NSLocalizedString("Transformations", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TransformationsViewCell", bundle: nil), forCellReuseIdentifier: "TransformationsViewCell")
        
        
    }
    
    //MARK: - Configure View Model
    private func configViewModel() {
        self.viewModel.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transformations in
                self?.tableView.reloadData()
            }
            .store(in: &suscriptors)
                
            }
    
    
    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self.viewModel.transformations.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transformation = self.viewModel.transformations[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransformationsViewCell", for: indexPath) as? TransformationsTableViewCell else { return
            UITableViewCell()}
        cell.configUI(with: transformation)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
        
}



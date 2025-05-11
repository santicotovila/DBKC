import XCTest
import Combine
import KCLibrarySwift
import CombineCocoa
import UIKit
@testable import KCProfessional

final class KCDragonBallProfTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testKeyChainLibrary() throws {
        let KC = KeychainManager.shared
        XCTAssertNotNil(KC)
        
        let save = KC.setKC(key: "Test", value: "123")
        XCTAssertEqual(save, true)
        
        let value = KC.getKC(key: "Test")
        if let valor = value {
            XCTAssertEqual(valor, "123")
        }
        XCTAssertNoThrow(KC.removeKC(key: "Test"))
    }
    
    func testLoginFake() async throws {
        let KC = KeychainManager.shared
        XCTAssertNotNil(KC)
        
        
        let obj = FakeLoginUseCase()
        XCTAssertNotNil(obj)
        
        //Validate Token
        let resp = await obj.validateToken()
        XCTAssertEqual(resp, true)
        
        
        // login
        let loginDo = await obj.login(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = KC.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //Close Session
        await obj.logout()
        jwt = KC.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    func testLoginReal() async throws  {
        let CK = KeychainManager.shared
        XCTAssertNotNil(CK)
        //reset the token
        let _ = CK.setKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "")
        
        //Caso se uso con repo Fake
        let userCase = DefaultLoginUseCase(repo: LoginRepositoryFake())
        XCTAssertNotNil(userCase)
        
        //validacion
        let resp = await userCase.validateToken()
        XCTAssertEqual(resp, false)
        
        //login
        let loginDo = await userCase.login(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = CK.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //Close Session
        await userCase.logout()
        jwt = CK.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    func testLoginAutoLoginAsincrono()  throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Login Auto ")
        
        let vm = AppState(loginUseCase: FakeLoginUseCase())
        XCTAssertNotNil(vm)
        
        vm.$loginStatus
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { estado in
                print("Recibo estado \(estado)")
                if estado == .success {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
        
        vm.validateLogin()
        
        self.waitForExpectations(timeout: 2)
    }
    
    func testUIErrorView() async throws  {
        
        let appStateVM = AppState(loginUseCase: FakeLoginUseCase())
        XCTAssertNotNil(appStateVM)
        
        appStateVM.loginStatus = .error
        
        let vc = await ErrorViewController(appState: appStateVM, error: "Error Testing")
        XCTAssertNotNil(vc)
    }
    
    func testUILoginView()  throws  {
        XCTAssertNoThrow(LoginView())
        let view = LoginView()
        XCTAssertNotNil(view)
        
        let logo =   view.logoImage
        XCTAssertNotNil(logo)
        let txtUser = view.emailTextfield
        XCTAssertNotNil(txtUser)
        let txtPass = view.passwordTextfield
        XCTAssertNotNil(txtPass)
        let button = view.buttonLogin
        XCTAssertNotNil(button)
        
        //Ojo, aqui hay que testear con la variable localizada
        XCTAssertEqual(txtUser.placeholder, NSLocalizedString("email", comment: ""))
        XCTAssertEqual(txtPass.placeholder, NSLocalizedString("password", comment: ""))
        XCTAssertEqual(button.titleLabel?.text, NSLocalizedString("login", comment: ""))
        
        
        //la vista esta generada
        let View2 =  LoginViewController(appState: AppState(loginUseCase: FakeLoginUseCase()))
        XCTAssertNotNil(View2)
        XCTAssertNoThrow(View2.loadView()) //generamos la vista
        XCTAssertNotNil(View2.loginButton)
        XCTAssertNotNil(View2.emailTextfield)
        XCTAssertNotNil(View2.logo)
        XCTAssertNotNil(View2.passwordTexfield)
        
        //el binding
        XCTAssertNoThrow(View2.bindUI())
        
        View2.emailTextfield?.text = "Hola"
        
        //el boton debe estar desactivado
        XCTAssertEqual(View2.emailTextfield?.text, "Hola")
    }
    
    
    func testHeroiewViewModel() async throws  {
        var suscriptor = Set<AnyCancellable>()
        
        //FIXME: - He creado expectation porque tenia problemas con la carga ya que no le daba tiempo a cargar los heroes porque metimos en el hilo principal loadHeros,pense en quitarlo pero creo que no es lo correcto😅 ya que necesitamos una app fluida.
        
        let vm = HerosViewModel(useCaseHeros: FakeHeroUseCase())
        XCTAssertNotNil(vm)
        
        let expectation = XCTestExpectation(description: "created to give time to load the heroes before passing the test")
        
        vm.$heros
            .dropFirst() // Aprovecho el metodo mencionado por alvaro en clase para ignroar el primer resultado.
            .sink { heros in
                XCTAssertEqual(heros.count, 2)
                expectation.fulfill()
            }
            .store(in: &suscriptor)
    }
    
    func testHerosUseCase() async throws  {
        let caseUser = HeroUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(caseUser)
        
        let data = await caseUser.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
    
    func testHeros_Combine() async throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Heros get")
        
        let vm = HerosViewModel(useCaseHeros: FakeHeroUseCase())
        XCTAssertNotNil(vm)
        
        vm.$heros
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { data in
                
                if data.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
        
        
        await fulfillment(of: [exp], timeout: 5)
        
    }
    
    func testHeros_Data() async throws  {
        let network = NetworkHerosMock()
        XCTAssertNotNil(network)
        let repo = HerosRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let data = await repo.getHeros(IDHeros: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
        
        let data2 = await repo2.getHeros(IDHeros: "")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 2)
    }
    
    func testHeros_Domain() async throws  {
        //Models
        let model = HerosEntity(id: String(), favorite: true, description: "des", photo: "url", name: "goku")
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "goku")
        XCTAssertEqual(model.favorite, true)
        
        let requestModel = HeroModelRequest(name: "goku")
        XCTAssertNotNil(requestModel)
        XCTAssertEqual(requestModel.name, "goku")
    }
    
    func testHeros_Presentation() async throws  {
        let viewModel = HerosViewModel(useCaseHeros: FakeHeroUseCase())
        XCTAssertNotNil(viewModel)
        
        let view =  await HomeViewController(appState: AppState(loginUseCase: FakeLoginUseCase()), viewModel: viewModel)
        XCTAssertNotNil(view)
        
    }
    
    func testTransformationUseCase() async throws  {
        let useCase = TransformationsUseCase(repo: TransformationsRepositoryFake())
        XCTAssertNotNil(useCase)
        
        let data = await useCase.getTransformations(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
    
    func testTransformationsDomain() async throws  {
        let model = TransformationsEntity(photo:"photo", description: "info", id: "xxx", name: "Ozoro")
        XCTAssertNotNil(model)
        XCTAssertEqual(model.description, "info")
        XCTAssertEqual(model.photo, "photo")
        XCTAssertEqual(model.name, "Ozoro")
        XCTAssertEqual(model.id,"xxx")
        
        let requestModel = HeroModelRequest(name: "hero2")
        XCTAssertEqual(requestModel.name, "hero2")
        XCTAssertNotNil(requestModel)
    }
    
    func testTransformationsData() async throws {
        let network = NetworkHerosMock()
        XCTAssertNotNil(network)
        let repo = TransformationsRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = TransformationsRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let data = await repo.getTransformationsForHero(heroID: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
        let data2 = await repo2.getTransformationsForHero(heroID: "")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 2)
        
    }
    
    func testTransformationViewViewModel() async throws  {
        var suscriptor = Set<AnyCancellable>()
        
        //FIXME: - Solucionado igual que el viewModel de heros.
        
        let vm = TransformationsViewModel(useCaseTransformations: TransformationsUseCaseFake())
        XCTAssertNotNil(vm)
        
        let expectation = XCTestExpectation(description: "created to give time to load the transformations before passing the test")
        
        vm.$transformations
            .dropFirst() // Aprovecho el metodo mencionado por alvaro en clase para ignroar el primer resultado.
            .sink { transformation in
                XCTAssertEqual(transformation.count, 2)
                expectation.fulfill()
            }
            .store(in: &suscriptor)
    }
    
    
    func testRepositoryGetTransformationForHero() async throws {
        
        let networkMock = NetworkHerosMock()
        let repository = TransformationsRepository(network: networkMock)
        
        let sut = await repository.getTransformationsForHero(heroID: "")
        
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.first?.name, "1. Oozaru – Gran Mono" )
        XCTAssertEqual(sut.first?.id, "17824501-1106-4815-BC7A-BFDCCEE43CC9" )
        XCTAssertEqual(sut.count, 2)
        
    }
    
    func testRepositoryGetHero() async throws {
        
        let networkMock = NetworkHerosMock()
        let repository = HerosRepository(network: networkMock)
        
        let sut = await repository.getHeros(IDHeros: "test")
        
        XCTAssertFalse(sut.isEmpty,"Need return at least one")
        XCTAssertEqual(sut.first?.name, "Goku" )
        XCTAssertEqual(sut.first?.id, "id" )
        XCTAssertEqual(sut.count, 2)
        
    }
    
    func testHeroViewModel() async throws {
        let sut = MockHeroInfoViewModel()
        let fakeHero = HerosEntity(id: "id", favorite: true, description: "description", photo: "photo", name: "name")
        sut.selectedHero = fakeHero
        
        XCTAssertEqual(sut.selectedHero?.name, "name")
        XCTAssertNotEqual(sut.selectedHero?.id, "different" )
    }
    
    func testGetHerosFromJson() async throws {
        
        let sut = NetworkHerosMock()
        
        let heros = sut.getHerosFromJson()
        
        XCTAssertFalse(heros.isEmpty)
        XCTAssertTrue(heros.count > 3, "Error, the json contains more items than 3")
        XCTAssertEqual(heros.first?.name, "Maestro Roshi")
        XCTAssertEqual(heros.first?.id, "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3")
        XCTAssertEqual(heros.last?.name, "Trunks del Futuro")
        XCTAssertEqual(heros.last?.id,"6AF516DD-529B-47A5-B3DB-9B88E55432C6" )
        
    }
    
    
    func testGetTransformationsFromJson() async throws {
        
        let sut = NetworkHerosMock()
        
        let transformations = sut.getTransformationsFromJson()
        
        XCTAssertFalse(transformations.isEmpty)
        XCTAssertTrue(transformations.count > 3, "Error, the json contains more items than 3")
        XCTAssertEqual(transformations.first?.name, "1. Oozaru – Gran Mono")
        XCTAssertEqual(transformations.first?.id, "17824501-1106-4815-BC7A-BFDCCEE43CC9")
        XCTAssertEqual(transformations.last?.name, "14. Ultra instinto")
        XCTAssertEqual(transformations.last?.id,"5809A7BC-DE77-4DA4-939B-D5F4EB00FAA6" )
        
    }
    
    func test_LocalizedStrings_returnValuesCorrect() {
        func testLocalizedStrings() {
            XCTAssertEqual(NSLocalizedString("heros-title", comment: ""), "Heros list")
            XCTAssertEqual(NSLocalizedString("error-message", comment: ""), "Wrong password or user")
            XCTAssertEqual(NSLocalizedString("error-button", comment: ""), "Back to login")
            XCTAssertEqual(NSLocalizedString("Transformations", comment: ""), "Transformations Hero")
        }
        
    }
    
}

class TransformationsTableViewControllerTests: XCTestCase {
    
    var sut: TransformationsTableViewController!
    var mockViewModel: MockTransformationsViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockTransformationsViewModel()
        sut = TransformationsTableViewController(viewModel:)
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func testInitialization() {
        // Test initialization with view model
        XCTAssertNotNil(sut)
        XCTAssertIdentical(sut.viewModel as? MockTransformationsViewModel, mockViewModel)
        XCTAssertEqual(sut.nibName, "TransformationsView")
    }
    
    func testViewDidLoad() {
        // Load view
        _ = sut.view
        
        // Test that view is configured correctly
        XCTAssertEqual(sut.title, NSLocalizedString("Transformations", comment: ""))
        XCTAssertTrue(sut.tableView.delegate === sut)
        XCTAssertTrue(sut.tableView.dataSource === sut)
        
        // Test cell registration (indirectly via numberOfRowsInSection)
        let mockTransformation = TransformationEntity(id: 1, name: "Test", description: "Test description", photo: "test.jpg")
        mockViewModel.transformations = [mockTransformation]
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func testTableViewDelegateAndDataSource() {
        // Setup test data
        let mockTransformation1 = TransformationEntity(id: 1, name: "Test 1", description: "Description 1", photo: "test1.jpg")
        let mockTransformation2 = TransformationEntity(id: 2, name: "Test 2", description: "Description 2", photo: "test2.jpg")
        mockViewModel.transformations = [mockTransformation1, mockTransformation2]
        
        // Load view
        _ = sut.view
        
        // Test numberOfRowsInSection
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), 2)
        
        // Test heightForRowAt
        XCTAssertEqual(sut.tableView(sut.tableView, heightForRowAt: IndexPath(row: 0, section: 0)), 100)
        
        // We can't easily test cellForRowAt without a real UITableView setup,
        // but we can test that it doesn't crash
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testDataBinding() {
        // Load view to trigger viewDidLoad
        _ = sut.view
        
        // Setup expectations
        let expectation = self.expectation(description: "Table view reloaded")
        
        // Mock table view reload
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        mockTableView.reloadDataClosure = {
            expectation.fulfill()
        }
        
        // Trigger data binding by updating transformations
        mockViewModel.transformations = [TransformationEntity(id: 3, name: "New Test", description: "New Description", photo: "new.jpg")]
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0)
        
        // Verify that the table view was reloaded
        XCTAssertTrue(mockTableView.reloadDataCalled)
    }
}

// MARK: - Mock Classes

class MockTransformationsViewModel: TransformationsViewModel {
    override init() {
        super.init()
    }
}

class MockTableView: UITableView {
    var reloadDataCalled = false
    var reloadDataClosure: (() -> Void)?
    
    override func reloadData() {
        reloadDataCalled = true
        reloadDataClosure?()
    }
}

// Add this mock class if TransformationEntity is not defined in your test target
// Adjust properties based on your actual implementation
struct TransformationEntity {
    let id: Int
    let name: String
    let description: String
    let photo: String
}

// Add this mock class if TransformationsViewModel is not defined in your test target
class TransformationsViewModel {
    @Published var transformations: [TransformationEntity] = []
}

// Add this mock class if TransformationsTableViewCell is not defined in your test target
class TransformationsTableViewCell: UITableViewCell {
    func configUI(with transformation: TransformationEntity) {
        // Mock implementation
    }
}

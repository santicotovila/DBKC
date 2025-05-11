import Foundation
import Combine


final class HeroInfoViewModel: ObservableObject {
    
    @Published var selectedHero: HerosEntity?
}


final class MockHeroInfoViewModel: ObservableObject {
    @Published var selectedHero: HerosEntity?
}

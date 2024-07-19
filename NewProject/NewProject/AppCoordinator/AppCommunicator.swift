import SwiftUI

// MARK: - protocol CharactersNavigator

protocol CharactersNavigator {
    func characterDetail()
    func filters()
}

// MARK: - BaseCoordinator

final class BaseCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentSheetItem: DestinationFlowPage?
    @Published var fullCoverItem: DestinationFlowPage?
    
    func gotoRoot() {
        path.removeLast(path.count)
    }
    
    func removeLast() {
        path.removeLast()
    }
}

// MARK: - extension BaseCoordinator

extension BaseCoordinator: CharactersNavigator {
    func filters() {
        presentSheetItem = .filter
    }
    
    func characterDetail() {
        path.append(DestinationFlowPage.characterDetail)
    }
}

// MARK: - enum DestinationFlowPage

enum DestinationFlowPage: Hashable, Identifiable {
    static func == (
        lhs: DestinationFlowPage,
        rhs: DestinationFlowPage
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case listOfCharacters
    case characterDetail
    case filter
    
    var id: String {
        String(describing: self)
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .listOfCharacters:
            hasher.combine("tabBar")
        case .characterDetail:
            hasher.combine("character")
        case .filter:
            hasher.combine("filter")
        }
    }
}

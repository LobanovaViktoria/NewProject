import SwiftUI

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

protocol CharactersNavigator {
    func characterDetail()
    func filters()
}

extension BaseCoordinator: CharactersNavigator {
    func filters() {
        presentSheetItem = .filter
    }
    
    func characterDetail() {
        path.append(DestinationFlowPage.characterDetail)
    }
}

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

protocol AnyDataModel {
    var data: Any? { get set }
    var index: Int? { get set }
    var id: String? { get set }
}

import SwiftUI

class ViewFactory: ObservableObject {
    
    @ViewBuilder static func viewForDestination(_ destination: DestinationFlowPage) -> some View {
        switch destination {
        case .listOfCharacters:
            self.getList()
        case .characterDetail:
            self.getDetail()
        case .filter:
            self.getFilter()
        }
    }
    
    static func getList() -> some View {
        ListOfCharactersView()
    }
    
    static func getDetail() -> some View {
        CharacterDetailView()
    }
    
    static func getFilter() -> some View {
        FilterView()
    }
}

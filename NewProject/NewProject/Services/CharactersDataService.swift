import Foundation
import Combine

class CharactersDataService {
    
    // MARK: - Properties
    
    @Published var allCharacters: [CharacterModel] = []
    @Published var isBusy: Bool = false
    @Published var state: AppState = .success
    
    private var selectedStatus: Status? = nil
    private var selectedGender: Gender? = nil
    private var searchName: String? = nil
    private var info: Info? = nil
    private var currentPage: Int = 1
    private var refresh: Bool = false
   
    var charactersSubscription: AnyCancellable?
    
    // MARK: - Init
    
    init() {
        getCharacters(
            for: currentPage,
            gender: nil,
            status: nil,
            searchName: nil
        )
    }
    
    // MARK: - Methods
    
    func loadNextPage() {
        if let pages = info?.pages, pages > currentPage {
            getCharacters(
                for: currentPage + 1,
                gender: selectedGender,
                status: selectedStatus,
                searchName: searchName
            )
        }
    }
    
    func applyFilters(gender: Gender?, status: Status?) {
        let filtersChanged = selectedStatus != status || selectedGender != gender
        
        selectedStatus = status
        selectedGender = gender
        
        if filtersChanged {
            currentPage = 1
            refresh = true
        }
        
        getCharacters(
            for: currentPage,
            gender: gender,
            status: status,
            searchName: searchName
        )
    }
    
    func searchTextUpdated(searchText: String?) {
        let textChanged = searchName != searchText
        
        searchName = searchText
        if textChanged {
            currentPage = 1
            refresh = true
        }
        
        getCharacters(
            for: currentPage,
            gender: selectedGender,
            status: selectedStatus,
            searchName: searchText
        )
    }
    
    func isLastPage() -> Bool {
        info?.pages == currentPage
    }
    
    private func getCharacters(
        for page: Int,
        gender: Gender?,
        status: Status?,
        searchName: String?
    ) {
        let baseString = "https://rickandmortyapi.com/api/character/"
        var requestString = baseString + "?page=\(page)"
        if let gender {
            requestString += "&gender=\(gender.rawValue)"
        }
        if let status {
            requestString += "&status=\(status.rawValue)"
        }
        if let searchName {
            requestString += "&name=\(searchName)"
        }
        guard let url = URL(string: requestString) else { return }
        performRequest(with: url, page: page)
    }
    
    private func performRequest(with url: URL, page: Int) {
        isBusy = true
        charactersSubscription = NetworkingManager
            .download(url: url)
            .decode(type: CharactersResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    print("Publisher is finished")
                    state = .success
                case .failure(let error):
                    if let err = error as? NetworkingManager.NetworkingError, err == .resultIsEmpty {
                        allCharacters = []
                        state = .success
                    } else {
                        state = .failed
                    }
                    isBusy = false
                    refresh = false
                    
                    print(error)
                }
            }, receiveValue: { [weak self] returnedCharacters in
                guard let self else { return }
                if refresh {
                    allCharacters = returnedCharacters.results
                } else {
                    allCharacters += returnedCharacters.results
                }
                currentPage = page
                info = returnedCharacters.info
                isBusy = false
                refresh = false
                charactersSubscription?.cancel()
                state = .success
            }
        )
    }
}

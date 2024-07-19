import Foundation
import Combine

final class ListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var state = AppState.success
    @Published var characters: [CharacterModel]? = []
    @Published var selectedCharacter: CharacterModel?
    @Published var episodesID: [String] = []
    @Published var stringFromEpisodes: String = ""
    @Published var episodes: [Episode]? = []
    @Published var episodesName: [String] = []
    @Published var isBusy: Bool = false
    @Published var searchText: String = ""
    @Published var selectedStatus: Status? = nil
    @Published var selectedGender: Gender? = nil
    @Published var filterIsApplied: Bool = false
    
    private let characterDataService: CharactersDataService
    private let episodeDataService: EpisodeDataService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        self.characterDataService = CharactersDataService()
        self.episodeDataService = EpisodeDataService()
        addSubscribers()
    }
    
    // MARK: - Methods
    
    func statusChange(item: Status) {
        if item == selectedStatus {
            selectedStatus = nil
        } else {
            selectedStatus = item
        }
    }
    
    func genderChange(item: Gender) {
        if item == selectedGender {
            selectedGender = nil
        } else {
            selectedGender = item
        }
    }
    
    func resetFilters() {
        filterIsApplied = false
        selectedGender = nil
        selectedStatus = nil
        refresh()
    }
    
    func refresh() {
        applyFilters()
    }
    
    func applyFilters() {
        characterDataService.applyFilters(gender: selectedGender, status: selectedStatus)
        filterIsApplied = selectedGender != nil || selectedStatus != nil
    }
    
    func updateSearchText() {
        characterDataService.searchTextUpdated(searchText: searchText)
    }
    
    func loadNextPage() {
        characterDataService.loadNextPage()
        state = characterDataService.state
    }
    
    func isLastPage() -> Bool {
        characterDataService.isLastPage()
    }
    
    func updateEpisodes() {
        episodesID = []
        selectedCharacter = nil
        episodes = []
        stringFromEpisodes = ""
        episodesName = []
        episodeDataService.updateEpisodes()
    }
    
    func getEpisodes() {
        if let episodes = selectedCharacter?.episode {
            for episode in episodes {
                let fileArray = episode.components(separatedBy: "/")
                if let finalFileName = fileArray.last {
                    self.episodesID.append(finalFileName)
                }
            }
            stringFromEpisodes = self.episodesID.joined(separator: ",")
        }
        if selectedCharacter?.episode?.count == 1 {
            episodeDataService.getEpisode(id: stringFromEpisodes)
        } else {
            episodeDataService.getEpisodes(id: stringFromEpisodes)
        }
        
        episodeDataService.$episodes
            .sink { [weak self] returnedEpisodes in
                self?.episodes = returnedEpisodes
                self?.episodesName = self?.transformEpisodesFromString(episodes: self?.episodes ?? []) ?? []
            }
            .store(in: &cancellables)
        state = episodeDataService.state
    }
    private func transformEpisodesFromString(episodes: [Episode]) -> [String] {
        var str: [String] = []
        for episode in episodes {
            let name = episode.name
            str.append(name)
        }
        return str
    }
    
    private func addSubscribers() {
        characterDataService.$allCharacters
            .sink { [weak self] allCharacters in
                self?.characters = allCharacters
            }
            .store(in: &cancellables)
        
        characterDataService.$isBusy
            .sink { [weak self] isBusy in
                self?.isBusy = isBusy
            }
            .store(in: &cancellables)
        characterDataService.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}

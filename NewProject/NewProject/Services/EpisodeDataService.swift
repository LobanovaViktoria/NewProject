import Foundation
import Combine

class EpisodeDataService {
    
    // MARK: - Properties
    
    @Published var episodes: [Episode]?
    @Published var state: AppState = .success
    
    var episodesSubscription: AnyCancellable?
    
    // MARK: - Methods
    
    func getEpisodes(id: String) {
        guard let url = URL(string: ("https://rickandmortyapi.com/api/episode/" + id)) else { return }
        
        episodesSubscription = NetworkingManager
            .download(url: url)
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    print("Publisher is finished")
                    state = .success
                case .failure(let error):
                    state = .failed
                    print(error)
                }
            }, receiveValue: { [weak self] (returnedEpisodes) in
                guard let self else { return }
                episodes = returnedEpisodes
                episodesSubscription?.cancel()
                state = .success
            }
        )
    }
    
    func getEpisode(id: String) {
        guard let url = URL(string: ("https://rickandmortyapi.com/api/episode/" + id)) else { return }
        
        episodesSubscription = NetworkingManager
            .download(url: url)
            .decode(type: Episode.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedEpisodes) in
                guard let self else { return }
                episodes = [returnedEpisodes]
                episodesSubscription?.cancel()
            }
        )
    }
    
    func updateEpisodes() {
        self.episodes = []
    }
}

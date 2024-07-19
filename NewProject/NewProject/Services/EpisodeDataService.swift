import Foundation
import Combine

class EpisodeDataService {
    
    @Published var episodes: [Episode]?
    @Published var state: AppState = .success
    
    var episodesSubscription: AnyCancellable?
    
    func getEpisodes(id: String) {
        guard let url = URL(string: ("https://rickandmortyapi.com/api/episode/" + id)) else { return }
        
        episodesSubscription = NetworkingManager.download(url: url)
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher is finished")
                    self.state = .success
                case .failure(let error):
                    self.state = .failed
                    print(error)
                }
            }, receiveValue: { [weak self] (returnedEpisodes) in
                self?.episodes = returnedEpisodes
                self?.episodesSubscription?.cancel()
                self?.state = .success
            })
            
    }
    
    func getEpisode(id: String) {
        guard let url = URL(string: ("https://rickandmortyapi.com/api/episode/" + id)) else { return }
        
        episodesSubscription = NetworkingManager.download(url: url)
            .decode(type: Episode.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedEpisodes) in
                self?.episodes = [returnedEpisodes]
                self?.episodesSubscription?.cancel()
            })
    }
    
    func updateEpisodes() {
        self.episodes = []
    }
}

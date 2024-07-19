import Foundation
import Combine

class NetworkingManager {
    
    // MARK: - enum NetworkingError
    
    enum NetworkingError: LocalizedError, Equatable {
        case badURLResponse(url: URL)
        case resultIsEmpty
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                "Bad response from URL: \(url)"
            case .unknown:
                "Unknown error occurred"
            case .resultIsEmpty:
                "There is nothing here"
            }
        }
    }
    
    // MARK: - Methods
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({
                try handleURLResponse(output: $0, url: url)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(
        output: URLSession.DataTaskPublisher.Output,
        url: URL
    ) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            if (output.response as? HTTPURLResponse)?.statusCode == 404 {
                throw NetworkingError.resultIsEmpty
            } else {
                throw NetworkingError.badURLResponse(url: url)
            }
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

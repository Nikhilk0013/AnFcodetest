import Foundation
import Combine


class ANFExploreCardService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImlp()) {
        self.networkService = networkService
    }

    func fetchPromotions() -> AnyPublisher<[Promotion], Error> {
        guard let url = APIConfig.promotionsURL else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return networkService.fetch(url: url)
            .map { (response: [Promotion]) in response }
            .eraseToAnyPublisher()
    }
}

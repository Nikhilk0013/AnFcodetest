import Combine
import UIKit
import Foundation

class ANFExploreCardTableViewModel {
    var items = [Promotion]()
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    private let andExploreCardService: ANFExploreCardService
    private var cancellables = Set<AnyCancellable>()
    
    init(andExploreCardService: ANFExploreCardService = ANFExploreCardService()) {
        self.andExploreCardService = andExploreCardService
    }
    
    func fetchPromotions() {
        
        andExploreCardService.fetchPromotions()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching photos: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] photos in
                self?.items = photos
                self?.reloadData?()
            }
            .store(in: &cancellables)
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

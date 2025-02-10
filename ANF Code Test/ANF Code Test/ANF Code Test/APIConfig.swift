import Foundation

struct APIConfig {
    static let baseURL = "https://www.abercrombie.com/"
    
    static var promotionsURL: URL? {
        return URL(string: "\(baseURL)anf/nativeapp/qa/codetest/codeTest_exploreData.css")
    }
}

import Foundation
import SwiftUI

class TaskAPIClient {
    static let shared = TaskAPIClient()
    private init() {}

    func sendRequest<T: Codable>(url: URL,
                                 method: String,
                                 body: Codable? = nil,
                                 completion: @escaping (Result<T, Error>) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}

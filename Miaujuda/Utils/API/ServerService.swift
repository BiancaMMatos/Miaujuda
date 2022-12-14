import Foundation
import AuthenticationServices

class ServerService {
    public static var shared = ServerService()
    private let baseUrl: String = "https://project-pets.herokuapp.com"
    private let jwtToken = UserDefaults.standard.string(forKey: "jwtToken")
    
    // MARK: --- Get request
    func getRequest(route: UrlRoute, id: String = "", completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + route.rawValue + (id != "" ? "/" + id : "")) else { return }
        var request = URLRequest(url: url)
        guard let jwtToken = self.jwtToken else { return }
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    guard let responseJson = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                    completion(.success(responseJson))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    // MARK: --- Get all PetPosts
    func getAllPetPosts(completion: @escaping (Result<[PetPost], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + UrlRoute.petPost.rawValue) else { return }
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let responseJson = try JSONDecoder().decode([PetPost].self, from: data)
                    completion(.success(responseJson))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    // MARK: --- Get latest PetPost and User data
    func getLatestPetPost(completion: @escaping (Result<PetPostAndUser, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + UrlRoute.latestPetPost.rawValue) else { return }
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let petPostAndUserData = try JSONDecoder().decode(PetPostAndUser.self, from: data)
                    completion(.success(petPostAndUserData))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    // MARK: --- Get User by ID
        func getUserByID(_ id: String, completion: @escaping (Result<User, Error>) -> Void) {
            let session = URLSession.shared
            guard let url = URL(string: baseUrl + UrlRoute.user.rawValue + id) else { return }
            var request = URLRequest(url: url)
//            guard let jwtToken = self.jwtToken else { return }
//            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            session.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let responseJson = try JSONDecoder().decode(User.self, from: data)
                        completion(.success(responseJson))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
            .resume()
        }
    
    // MARK: --- Post request
    public func postRequest(route: UrlRoute, body: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + route.rawValue) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    guard let data = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                    completion(.success(data))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    // MARK: --- Create User
    public func createUser(userData: [String: Any], completion: @escaping (Result<User, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + UrlRoute.user.rawValue) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(data))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    // MARK: --- Authenticate User and Get JWT token
    func authenticate(appleID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + UrlRoute.auth.rawValue) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let appleIdData = ["appleID": appleID]
        guard let httpBody = try? JSONEncoder().encode(appleIdData) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    guard let data = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                    completion(.success(data))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    // MARK: --- Change PetPost status
    func updatePetPostStatus(id: String, status: PetPostStatus, completion: @escaping (Result<PetPost, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + UrlRoute.petPost.rawValue + id) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let statusData = ["status": status.rawValue]
        guard let httpBody = try? JSONEncoder().encode(statusData) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(PetPost.self, from: data)
                    completion(.success(data))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    // MARK: --- Delete PetPost
    func deletePetPost(_ id: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: baseUrl + UrlRoute.petPost.rawValue + id) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        session.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    guard let data = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                    completion(.success(data))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}

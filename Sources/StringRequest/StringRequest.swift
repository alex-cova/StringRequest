// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class StringRequest {
    
    public static var scheme : HttpScheme = .HTTP
    public static var host : String = "localhost"
    public static var authorization : String = ""
    public static var port = 8080
    
    static func build(requestEntity: RequestEntity) -> URLRequest? {
        
        
        guard let url = requestEntity.build() else {
            return nil
        }
        
        
        var request = URLRequest(url: url)
        
        if let b = requestEntity.body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: b)
        }
        
        if StringRequest.authorization.count > 0 {
            request.addValue("Bearer \(StringRequest.authorization)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = requestEntity.method.rawValue
        
        return request
    }
    
    static func doRequest<T : Decodable>(requestEntity : RequestEntity, target : T.Type) async -> ResponseEntity<T> {
        
        
        guard let request = build(requestEntity: requestEntity) else {
            return ResponseEntity(statusCode: 0, errorMessage: "Failed to build request")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            return handle(result: (data, response, nil), target: target)
        }catch {
            return ResponseEntity(statusCode: 0, errorMessage: "Failed to send request \(error)")
        }
        
    }
    
    
    static func handle<T : Decodable> (result : (Data?, URLResponse?, Error?), target : T.Type) -> ResponseEntity<T> {
        
        let error = result.2
        let response = result.1
        let data = result.0
        
        if let error = error {
            return ResponseEntity(statusCode: 0, errorMessage: "Request failed: \(error)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return ResponseEntity(statusCode: 0, errorMessage: "Request failed not httpResponse type")
        }
        
        
        guard let data = data else {
            return ResponseEntity(statusCode: httpResponse.statusCode, errorMessage: "")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return ResponseEntity(statusCode: httpResponse.statusCode,
                                  errorMessage: String(data: data, encoding: .utf8) ?? "Received \(httpResponse.statusCode) from the server")
            
        }
        
        if target == String.self {
            
            let result = String(data: data, encoding: .utf8)!
            
            return ResponseEntity(value:  result as! T, response: httpResponse)
            
        }
        
        
        do{
            let decoded = try JSONDecoder().decode(target, from: data)
            
            return ResponseEntity(value: decoded, response: httpResponse)
            
        }catch {
            return ResponseEntity(statusCode: httpResponse.statusCode, errorMessage: "Failed to parse body: \(error)")
        }
        
    }
    
    static func doRequest<T : Decodable>(requestEntity : RequestEntity, target : T.Type,  callback : @escaping (ResponseEntity<T>) -> Void) {
        
        guard let request = build(requestEntity: requestEntity) else {
            return callback(ResponseEntity(statusCode: 0, errorMessage: "Failed to build request"))
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error)  in
            
            callback(handle(result: (data, response, error), target: target))
            
            
        }
    }
    
}

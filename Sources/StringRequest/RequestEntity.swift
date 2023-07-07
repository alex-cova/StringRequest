//
//  File.swift
//  
//
//  Created by Alex on 07/07/23.
//

import Foundation

class RequestEntity {
    
    private var scheme : HttpScheme = StringRequest.scheme
    private var queryParams : [String:String] = [:]
    private var headers : [String:String] = [:]
    
    private var urlComponents = URLComponents()
    
    private var path : String
    private var authority : String?
    private var port : Int?
    
    private var url : URL?
    
    var body : Any?
    var method : HttpMethod
    
    
    init(method : HttpMethod, path: String){
        self.path = path
        self.method = method
        self.body = nil
    }
    
    init(method: HttpMethod, path : String, body : Any?) {
        self.path = path
        self.method = method
        self.body = body
    }
    
    func formatted(_ values : CVarArg...) -> RequestEntity {
        self.path = String(format: self.path, arguments: values)
        
        return self
    }
    
    
    func GET() -> RequestEntity {
        method = .GET
        return self
    }
    
    func POST() -> RequestEntity {
        method = .POST
        return self
    }
    
    func PUT() -> RequestEntity {
        method = .PUT
        return self
    }
    
    func DELETE() -> RequestEntity {
        method = .DELETE
        return self
    }
    
    func PATCH() -> RequestEntity {
        method = .PATCH
        return self
    }
    
    func withAuthority(_ authority : String) -> RequestEntity{
        self.authority = authority
        return self
    }
    
    func withHeader(_ key : String, _ value : CustomStringConvertible?) -> RequestEntity {
        
        if let value = value {
            headers[key] = "\(value)"
        }
        
        return self
    }
    
    func withHeaders(_ headers : [String:String]) -> RequestEntity {
        self.headers = headers
        
        return self
    }
    
    func withHeader(_ key : HttpHeader, _ value : CustomStringConvertible?) -> RequestEntity {
        
        if let value = value {
            headers[key.rawValue] = "\(value)"
        }
        
        return self
    }
    
    func withQueryParam(_ key : String, _ value : CustomStringConvertible?) -> RequestEntity {
        
        if let value = value {
            queryParams[key] = "\(value)"
        }
        
        return self
    }
    
    func send<T : Decodable>(_ type : T.Type = String.self) async -> ResponseEntity<T> {
        return await StringRequest.doRequest(requestEntity: self, target: type)
    }
    
    func send<T : Decodable>(body: Any?, _ type : T.Type = String.self) async -> ResponseEntity<T> {
        self.body = body
        
        return await StringRequest.doRequest(requestEntity: self, target: type)
    }
    
    func send<T : Decodable>(_ type : T.Type = String.self, consumer : @escaping (ResponseEntity<T>) -> Void) {
        StringRequest.doRequest(requestEntity: self, target: type, callback: consumer)
    }
    
    func send<T : Decodable>(body: Any?, _ type : T.Type = String.self, consumer : @escaping (ResponseEntity<T>) -> Void) {
        self.body = body
        
        StringRequest.doRequest(requestEntity: self, target: type, callback: consumer)
    }
    
    func build() -> URL? {
        
        if url != nil {
            return url
        }
        
        for entry in queryParams {
            urlComponents.queryItems?.append(URLQueryItem(name: entry.key, value: entry.value))
        }
        
        urlComponents.port = self.port ?? StringRequest.port
        urlComponents.host = self.authority ?? StringRequest.host
        urlComponents.scheme = self.scheme.rawValue
        urlComponents.path = self.path
        
        self.url =  urlComponents.url
        
        
        return url
    }
    
}

class BodyRequestEntity : RequestEntity {
    
    func send<T : Decodable>(_ body : Any, target: T.Type, callback : @escaping (ResponseEntity<T>) -> Void) {
        StringRequest.doRequest(requestEntity: self, target: target, callback: callback)
    }
    
}

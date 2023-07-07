//
//  File.swift
//  
//
//  Created by Alex on 07/07/23.
//

import Foundation

extension String {
    
    
    func formatted(_ values : CVarArg...) -> String {
        return String(format: self, arguments: values)
    }
    
    func newRequest(_ method: HttpMethod = .GET) -> RequestEntity {
        return RequestEntity(method: method, path: self)
    }
    
    func PATCH<T: Decodable>(_ body : Any, _ type: T.Type = String.self) async ->  ResponseEntity<T> {
        return  await StringRequest.doRequest(requestEntity: RequestEntity(method: .PATCH, path: self, body: body), target: type)
    }
    
    func PATCH<T : Decodable>(_ body : Any, _ type : T.Type = String.self, callback : @escaping (ResponseEntity<T>) -> Void) {
        StringRequest.doRequest(requestEntity: RequestEntity(method: .PATCH, path: self, body: body), target: type, callback: callback)
    }
    
    func PUT<T : Decodable>(_ body : Any, _ type : T.Type = String.self) async -> ResponseEntity<T> {
        return await StringRequest.doRequest(requestEntity: RequestEntity(method: .PUT, path: self, body: body), target: type)
    }
    
    func PUT<T : Decodable>(_ body : Any, _ type : T.Type = String.self, callback : @escaping (ResponseEntity<T>) -> Void) {
        StringRequest.doRequest(requestEntity: RequestEntity(method: .PUT, path: self, body: body), target: type, callback: callback)
    }
    
    func POST<T : Decodable>(_ body : Any, _ type : T.Type = String.self) async -> ResponseEntity<T> {
        return await StringRequest.doRequest(requestEntity: RequestEntity(method: .POST, path: self, body: body), target: type)
    }
    
    func POST<T : Decodable>(_ body : Any, _ type : T.Type = String.self, callback : @escaping (ResponseEntity<T>) -> Void) {
        StringRequest.doRequest(requestEntity: RequestEntity(method: .POST, path: self, body: body), target: type, callback: callback)
    }
    
    func GET<T : Decodable>(_ type : T.Type = String.self, callback : @escaping (ResponseEntity<T>) -> Void){
        StringRequest.doRequest(requestEntity: RequestEntity(method: .GET, path: self), target: type, callback: callback)
    }
    
    func GET<T : Decodable>(_ type : T.Type = String.self) async -> ResponseEntity<T> {
        return await StringRequest.doRequest(requestEntity: RequestEntity(method: .GET, path: self), target: type)
    }
    
    func DELETE<T : Decodable>(_ type : T.Type = String.self, callback : @escaping (ResponseEntity<T>) -> Void){
        StringRequest.doRequest(requestEntity: RequestEntity(method: .DELETE, path: self), target: type, callback: callback)
    }
    
    func DELETE<T : Decodable>(_ type : T.Type = String.self) async -> ResponseEntity<T>{
        return await StringRequest.doRequest(requestEntity: RequestEntity(method: .DELETE, path: self), target: type)
    }
    
    private func deserialize<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: jsonData)
            return object
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
        }
    }
    
}

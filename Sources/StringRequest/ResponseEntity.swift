//
//  File.swift
//  
//
//  Created by Alex on 07/07/23.
//

import Foundation


struct ResponseEntity<T>  {
    
    var value : T?
    var statusCode : Int
    var errorMessage : String
    var response : HTTPURLResponse
    
    init(statusCode: Int, errorMessage : String) {
        self.value = nil
        self.statusCode = statusCode
        self.errorMessage = errorMessage
        self.response = HTTPURLResponse()
    }
    
    
    init(value : T, response : HTTPURLResponse) {
        self.value = value
        self.statusCode = response.statusCode
        self.errorMessage = ""
        self.response = response
    }
    
    func header(_ key : String) -> String? {
        response.value(forHTTPHeaderField: key)
    }
    
    func isSuccess() -> Bool {
        return (200...299).contains(statusCode)
    }
    
    func isClientError() -> Bool {
        return (400...499).contains(statusCode)
    }
    
    func isServerError() -> Bool {
        return (500...599).contains(statusCode)
    }
    
}

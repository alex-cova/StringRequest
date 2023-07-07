//
//  File.swift
//  
//
//  Created by Alex on 07/07/23.
//

import Foundation

enum HttpHeader : String  {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case userAgent = "User-Agent"
    case acceptLanguage = "Accept-Language"
    case contentLength = "Content-Length"
    case acceptEncoding = "Accept-Encoding"
    case contentRange = "Content-Range"
    case retryAfter = "Retry-After"
    
}

enum HttpMethod : String{
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
    case PATCH = "PATCH"
}


enum HttpScheme : String  {
    case HTTP = "http"
    case HTTPS = "https"
}

enum HttpContentType : String {
    case applicationJson = "application/json"
    case applicationGraphql = "application/graphql"
}

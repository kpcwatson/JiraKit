//
//  JiraRequestBuilder.swift
//  JiraKit
//
//  Created by Kyle Watson on 9/11/17.
//
//

import Foundation
import SwiftLogger

public class JiraRequestBuilder {
    
    let host: String
    let version: String
    let endpointMethod: String
    var httpMethod: String?
    var queryItems: [URLQueryItem]?
    var postParams: [String]?
    var timeout: TimeInterval?
    
    public init(host: String, version: Int, endpointMethod: String) {
        self.host = host
        self.version = String(version)
        self.endpointMethod = endpointMethod
    }
    
    public func httpMethod(_ method: String) -> JiraRequestBuilder {
        httpMethod = method
        return self
    }
    
    public func queryParameters(_ params: [String: String]) -> JiraRequestBuilder {
        queryItems = params.flatMap { URLQueryItem(name: $0.key, value: $0.value) }
        return self
    }
    
    public func postParameters(_ params: [String: String]) -> JiraRequestBuilder {
        
        var pairs = [String]()
        params.forEach { (key, value) in
            let pair = key + "=" + value
            pairs.append(pair)
        }
        postParams = pairs
        
        return self
    }
    
    public func timeout(_ timeout: TimeInterval) -> JiraRequestBuilder {
        self.timeout = timeout
        return self
    }
    
    public func build() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.path = "/rest/api/\(version)/\(endpointMethod)"
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw JiraError.unableToConstructURL(host: components.host, path: components.path)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = postParams?.joined(separator: "&")
            .data(using: .utf8)
        
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        
        Logger.debug(self, "built URLRequest:", request)
        
        return request
    }
}

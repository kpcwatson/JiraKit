//
//  JiraKit.swift
//  JiraKit
//
//  Created by Kyle Watson on 9/11/17.
//
//

import Foundation
import SwiftLogger

public typealias SearchCompletion = (Data?, Error?) -> Void

private let defaultUrlSession = URLSession(configuration: URLSessionConfiguration.default)

open class Jira {
    
    let host: String
    let version: Int
    let urlSession: URLSession
    
    public init(host: String, version: Int = 2, urlSession: URLSession = defaultUrlSession) {
        self.host = host
        self.version = version
        self.urlSession = urlSession
    }
    
    public func search(query: JQLQuery, fields: [String]? = nil, completion: @escaping SearchCompletion) {
        search(query: String(describing: query), fields: fields, completion: completion)
    }
    
    public func search(query: String, fields: [String]? = nil, completion: @escaping SearchCompletion) {
        
        var queryParams = ["jql": query]
        if let fields = fields {
            queryParams["fields"] = fields.joined(separator: ",")
        }
        
        var request: URLRequest
        do {
            request = try JiraRequestBuilder(host: host, version: version, endpointMethod: "search")
                .queryParameters(queryParams)
                .build()
        } catch {
            Logger.error(self, error)
            completion(nil, error)
            return
        }
        
        Logger.debug("request: \(request)")
        
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                Logger.debug(self, "HTTP status code \(response.statusCode)")
            }
            
            completion(data, error)
        }.resume()
    }
}

public enum JiraError: Error {
    case unableToConstructURL(host: String?, path: String?)
}

//
//  JiraKit.swift
//  JiraKit
//
//  Created by Kyle Watson on 9/11/17.
//
//

import Foundation
import SwiftLogger

// project = GOAPPTV AND status = "PR Approved Ready for QA" ORDER BY issuetype
// project = GOAPPTV AND status in (Open, "PR Approved Ready for QA") AND assignee in (kwatson) ORDER BY issuetype,assignee

public typealias SearchCompletion = (Data?, Error?) -> Void

open class Jira {
    
    static let defaultUrlSession: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    let host: String
    let version: Int
    let urlSession: URLSession
    
    public init(host: String, version: Int = 2, urlSession: URLSession = defaultUrlSession) {
        self.host = host
        self.version = version
        self.urlSession = urlSession
    }
    
    public func search(query: JQLQuery, fields: [String]? = nil, completion: @escaping SearchCompletion) {
        search(query: query.queryString, fields: fields, completion: completion)
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
        
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                Logger.debug(self, "HTTP status code \(response.statusCode)")
            }
            
            completion(data, error)
        }
    }
}

public enum JiraError: Error {
    case unableToConstructURL(host: String?, path: String?)
}

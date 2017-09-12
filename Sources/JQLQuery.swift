//
//  JQLQuery.swift
//  JiraKit
//
//  Created by Kyle Watson on 9/11/17.
//
//

import Foundation

public typealias JQLClause = String

public struct JQLQuery {
    
    public let clauses: [JQLClause]
    
    public init(whereClause: JQLClause, orderClause: JQLClause?) {
        var clauses = [whereClause]
        
        if let orderClause = orderClause {
            clauses.append(orderClause)
        }
        
        self.init(clauses: clauses)
    }
    
    public init(clauses: [JQLClause]) {
        self.clauses = clauses
    }
}

extension JQLQuery: CustomStringConvertible {
    public var description: String {
        return clauses.joined(separator: " ")
    }
}

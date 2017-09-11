//
//  JQLExpression.swift
//  JiraKit
//
//  Created by Kyle Watson on 9/11/17.
//
//

import Foundation

public enum JQLOperator: String {
    case equals = "="
    case nequals = "!="
    case `in` = "IN"
    case notIn = "NOT IN"
    case contains = "~"
    case ncontains = "!~"
}

public struct JQLExpression: CustomStringConvertible {
    
    let field: String
    let op: JQLOperator
    let values: [String]
    
    public init(field: String, operator op: JQLOperator, values: [String]) {
        self.field = field
        self.op = op
        self.values = values.flatMap { "'\($0)'" }
    }
    
    public init(field: String, operator op: JQLOperator, value: String) {
        self.init(field: field, operator: op, values: [value])
    }
    
    public var description: String {
        var expression: [String] = [field, op.rawValue]
        
        switch op {
        case .in, .notIn:
            expression.append("(" + values.joined(separator: ",") + ")")
            
        case .equals, .nequals, .contains, .ncontains:
            expression += values
        }
        
        return expression.joined(separator: " ")
    }
}

//
//  SimpleJQLQueryBuilder.swift
//  JiraKit
//
//  Created by Kyle Watson on 9/11/17.
//
//

import Foundation

open class SimpleJQLQueryBuilder {
    
    var expressions = [JQLExpression]()
    var orderBy: JQLClause?
    
    public func expression(_ expression: JQLExpression) -> SimpleJQLQueryBuilder {
        expressions.append(expression)
        return self
    }
    
    // MARK: Project
    
    public func project(_ project: String) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "project", operator: .equals, value: project)
        expressions.append(expression)
        return self
    }
    
    // MARK: Type
    
    public func type(_ op: JQLOperator, _ types: [String]) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "type", operator: op, values: types)
        expressions.append(expression)
        return self
    }
    
    public func type(_ op: JQLOperator, _ type: String) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "type", operator: op, value: type)
        expressions.append(expression)
        return self
    }
    
    // MARK: Status
    
    public func status(_ op: JQLOperator, _ statuses: [String]) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "status", operator: op, values: statuses)
        expressions.append(expression)
        return self
    }
    
    public func status(_ op: JQLOperator, _ status: String) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "status", operator: op, value: status)
        expressions.append(expression)
        return self
    }
    
    // MARK: Text
    
    public func text(contains text: String) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "text", operator: .contains, value: text)
        expressions.append(expression)
        return self
    }
    
    // MARK: Assignee
    
    public func assignee(_ op: JQLOperator, _ assignees: [String]) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "assignee", operator: op, values: assignees)
        expressions.append(expression)
        return self
    }
    
    public func assignee(_ op: JQLOperator, _ assignee: String) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "assignee", operator: op, value: assignee)
        expressions.append(expression)
        return self
    }
    
    // MARK: Fix Version
    
    public func fixVersion(_ op: JQLOperator, _ versions: [String]) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "fixVersion", operator: op, values: versions)
        expressions.append(expression)
        return self
    }
    
    public func fixVersion(_ op: JQLOperator, _ version: String) -> SimpleJQLQueryBuilder {
        let expression = JQLExpression(field: "fixVersion", operator: op, value: version)
        expressions.append(expression)
        return self
    }
    
    // MARK: Order By
    
    public func order(by fields: [String]) -> SimpleJQLQueryBuilder {
        orderBy = "ORDER BY " + fields.joined(separator: ", ")
        return self
    }
    
    // MARK: Build
    
    public func build() -> JQLQuery {
        let whereClause = expressions.flatMap { String(describing: $0) }
            .joined(separator: " AND ")
        return JQLQuery(whereClause: whereClause, orderClause: orderBy)
    }
}

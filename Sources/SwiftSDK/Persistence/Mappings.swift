//
//  Mappings.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2019 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

class Mappings: NSObject {
    
    static let shared = Mappings()
    
    var tableToClassMappings = [String: String]()
    var columnToPropertyMappings = [String: [String: String]]()

    func mapTable(tableName: String, toClassNamed: String) {
        tableToClassMappings[tableName] = toClassNamed
    }
    
    func getTableToClassMappings() -> [String: String] {
        return tableToClassMappings
    }
    
    func removeTableToClassMappings() {
        tableToClassMappings.removeAll()
    }
    
    func mapColumn(columnName: String, toProperty: String, ofClassNamed: String) {        
        if var mappings = columnToPropertyMappings[ofClassNamed] {
            mappings[columnName] = toProperty
            columnToPropertyMappings[ofClassNamed] = mappings
        }
        else {
            let mappings = [columnName: toProperty]
            columnToPropertyMappings[ofClassNamed] = mappings
        }
    }
    
    func getColumnToPropertyMappings(className: String) -> [String: String] {
        if let mappings = columnToPropertyMappings[className] {
            return mappings
        }
        return [String: String]()
    }
    
    func removeColumnToPropertyMappings() {
        columnToPropertyMappings.removeAll()
    }
}

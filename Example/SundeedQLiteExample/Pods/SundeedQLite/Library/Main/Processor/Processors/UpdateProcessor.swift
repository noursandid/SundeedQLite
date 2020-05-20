//
//  SundeedUpdateProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class UpdateProcessor {
    func update(objectWrapper: ObjectWrapper,
                columns: [SundeedColumn],
                withFilters filters: [SundeedExpression<Bool>?]) throws {
        try Processor()
            .createTableProcessor
            .createTableIfNeeded(for: objectWrapper)
        guard objectWrapper.hasPrimaryKey else {
            throw SundeedQLiteError
                .primaryKeyError(tableName: objectWrapper.tableName)
        }
        let updateStatement = StatementBuilder()
            .updateStatement(tableName: objectWrapper.tableName)
        for column in columns {
            if let objects = objectWrapper.objects,
                objects.contains(where: { (arg0) -> Bool in
                    let (key, _) = arg0
                    return key == column.value
                }) {
                let attribute = objects[column.value]
                if let attribute = attribute as? ObjectWrapper,
                    let className = attribute.className {
                    if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                        self.saveForeignObjects(attributes: [attribute],
                                                primaryValue: primaryValue,
                                                column: column,
                                                className: className,
                                                updateStatement: updateStatement)
                    }
                } else if let attributes = attribute as? [ObjectWrapper?] {
                    if let firstAttribute = attributes.first as? ObjectWrapper,
                        let className = firstAttribute.className {
                        if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                            self.saveForeignObjects(attributes: attributes,
                                                    primaryValue: primaryValue,
                                                    column: column,
                                                    className: className,
                                                    updateStatement: updateStatement)
                        }
                    }
                } else if let attribute = attribute as? UIImage {
                    if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                        updateStatement
                            .add(key: column.value,
                                 value: attribute
                                    .dataTypeValue(forObjectID: primaryValue))
                    }
                } else if let attribute = attribute as? Date {
                    updateStatement.add(key: column.value,
                                        value: Sundeed.shared
                                            .dateFormatter.string(from: attribute))
                } else if let attributes = attribute as? [UIImage?] {
                    let attributes = attributes.compactMap({$0})
                    if !attributes.isEmpty {
                        if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                            self.saveArrayOfImages(attributes: attributes,
                                                   primaryValue: primaryValue,
                                                   column: column,
                                                   updateStatement: updateStatement)
                        }
                    }
                } else if let attributes = attribute as? [Any] {
                    let attributes = attributes.compactMap({$0})
                    if !attributes.isEmpty {
                        if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                            Processor()
                                .saveProcessor
                                .saveArrayOfPrimitives(tableName: column.value,
                                                       objects: attributes,
                                                       withForeignKey: primaryValue)
                            updateStatement
                                .add(key: column.value,
                                     value: Sundeed.shared
                                        .sundeedPrimitiveForeignValue(tableName: column.value))
                        }
                    }
                } else {
                    if let attribute = attribute {
                        let attributeString = "\(attribute as AnyObject)"
                        updateStatement.add(key: column.value,
                                            value: attributeString)
                    } else {
                        updateStatement.add(key: column.value,
                                            value: "")
                    }
                }
            } else {
                throw SundeedQLiteError
                    .noColumnWithThisName(tableName: objectWrapper.tableName,
                                          columnName: column.value)
            }
        }
        updateStatement.withFilters(filters)
        let query = updateStatement.build()
        SundeedQLiteConnection.pool.execute(query: query)
    }
    
    func saveArrayOfImages(attributes: [UIImage],
                           primaryValue: String,
                           column: SundeedColumn,
                           updateStatement: UpdateStatement) {
            let attributes: [String] = attributes.enumerated()
                .map({
                    let index = $0
                    let indexString = String(describing: index)
                    let objectID = "\(primaryValue)\(column.value)\(indexString)"
                    return $1.dataTypeValue(forObjectID: objectID)
                })
            Processor()
                .saveProcessor
                .saveArrayOfPrimitives(tableName: column.value,
                                       objects: attributes,
                                       withForeignKey: primaryValue)
            updateStatement
                .add(key: column.value,
                     value: Sundeed.shared
                        .sundeedPrimitiveForeignValue(tableName: column.value))
    }
    
    
    func saveForeignObjects(attributes: [ObjectWrapper?],
                            primaryValue: String,
                            column: SundeedColumn,
                            className: String,
                            updateStatement: UpdateStatement) {
        Processor()
            .saveProcessor
            .save(objects: attributes.compactMap({$0}),
                  withForeignKey: primaryValue,
                  withFieldNameLink: column.value)
        
        updateStatement
            .add(key: column.value,
                 value: Sundeed.shared
                    .sundeedForeignValue(tableName: className,
                                         fieldNameLink: column.value))
    }
}

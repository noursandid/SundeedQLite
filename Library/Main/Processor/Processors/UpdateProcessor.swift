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
                withFilters filters: [SundeedExpression<Bool>?]){
        do {
            try Processor()
                .createTableProcessor
                .createTableIfNeeded(for: objectWrapper)
            guard objectWrapper.hasPrimaryKey else {
                throw SundeedQLiteError
                    .PrimaryKeyError(tableName: objectWrapper.tableName ?? "")
            }
            let updateStatement = StatementBuilder()
                .updateStatement(tableName: objectWrapper.tableName ?? "")
            for column in columns {
                if let objects = objectWrapper.objects,
                    objects.contains(where: { (arg0) -> Bool in
                        let (key,_) = arg0
                        return key == column.value
                    }) {
                    let attribute = objects[column.value]
                    if let attribute = attribute as? ObjectWrapper,
                        let className = attribute.className {
                        if let attributePrimaryValue = attribute
                            .objects?[Sundeed.shared.primaryKey] as? String {
                            if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                Processor()
                                    .saveProcessor
                                    .save(objects: [attribute],
                                          withForeignKey: primaryValue)
                            }
                            updateStatement.add(key: column.value,
                                                value: Sundeed.shared.sundeedForeignValue(tableName: className, foreignKey: attributePrimaryValue))
                        }
                    } else if let attribute = attribute as? [ObjectWrapper?]{
                        if let firstAttribute = attribute.first as? ObjectWrapper,
                            let className = firstAttribute.className{
                            if let primaryValue = firstAttribute
                                .objects?[Sundeed.shared.primaryKey] as? String {
                                Processor()
                                    .saveProcessor
                                    .save(objects: attribute.compactMap({$0}),
                                          withForeignKey: primaryValue)
                            }
                            updateStatement
                                .add(key: column.value,
                                     value: Sundeed.shared
                                        .sundeedForeignValue(tableName: className))
                        }
                    } else if let attribute = attribute as? UIImage {
                        if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                            updateStatement
                                .add(key: column.value,
                                     value: attribute
                                        .dataTypeValue(forObjectID: primaryValue))
                        }
                    } else if let attribute = attribute as? Date{
                        updateStatement.add(key: column.value,
                                            value: Sundeed.shared
                                                .dateFormatter.string(from: attribute))
                    } else if let attribute = attribute as? [UIImage] {
                        if attribute.count > 0 {
                            if let primaryValue = objects[Sundeed.shared.primaryKey] as? String,
                                let firstAttribute = attribute.first{
                                let attribute = attribute
                                    .map({$0.dataTypeValue(forObjectID:
                                        "\(primaryValue)\(column.value)\(String(describing: firstAttribute))")})
                                
                                Processor()
                                    .saveProcessor
                                    .saveArrayOfPrimitives(tableName: column.value,
                                                           objects: attribute,
                                                           withForeignKey: primaryValue)
                                updateStatement
                                    .add(key: column.value,
                                         value: Sundeed.shared
                                            .sundeedPrimitiveForeignValue(tableName: column.value))
                            }
                        }
                    } else if let attribute = attribute as? [Any] {
                        if attribute.count > 0 {
                            if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                Processor()
                                    .saveProcessor
                                    .saveArrayOfPrimitives(tableName: column.value,
                                                           objects: attribute,
                                                           withForeignKey: primaryValue)
                                
                                updateStatement
                                    .add(key: column.value,
                                         value: Sundeed.shared
                                            .sundeedPrimitiveForeignValue(tableName: column.value))
                            }
                        }
                    } else {
                        let attributeString = "\(attribute ?? "" as AnyObject)"
                        updateStatement.add(key: column.value,
                                            value: attributeString)
                    }
                } else {
                    throw SundeedQLiteError
                        .NoColumnWithThisName(tableName: objectWrapper.tableName ?? "",
                                              columnName: column.value)
                }
            }
            updateStatement.withFilters(filters)
            let query = updateStatement.build()
            SundeedQLiteConnection.pool.execute(query: query)
        } catch{}
    }
}

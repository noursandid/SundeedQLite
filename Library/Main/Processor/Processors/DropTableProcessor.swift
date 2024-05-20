//
//  DropTableProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 20/05/2024.
//  Copyright © 2024 LUMBERCODE. All rights reserved.
//

import Foundation

class DropTableProcessor {
    func dropTable(tableName: String) async {
        let dropTableStatement = DropTableStatement(with: tableName).build()
        await SundeedQLiteConnection.pool.execute(query: dropTableStatement,
                                            parameters: nil)
        Sundeed.shared.tables.removeAll(where: {$0 == tableName})
    }
}

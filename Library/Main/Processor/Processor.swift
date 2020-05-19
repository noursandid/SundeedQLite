//
//  SundeedQLiteHandler.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/9/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class Processor {
    var createTableProcessor: CreateTableProcessor {
        CreateTableProcessor()
    }
    var saveProcessor: SaveProcessor {
        SaveProcessor()
    }
    var retrieveProcessor: RetrieveProcessor {
        RetrieveProcessor()
    }
    var updateProcessor: UpdateProcessor {
        UpdateProcessor()
    }
}

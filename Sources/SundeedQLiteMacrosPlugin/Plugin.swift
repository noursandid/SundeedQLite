//
//  Plugin.swift
//  SundeedQLiteMacrosPlugin
//
//  Created by SundeedQLite on 2026.
//  Copyright © 2026 LUMBERCODE. All rights reserved.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SundeedQLiteMacrosPluginEntry: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SundeedQLiteModelMacro.self,
        SundeedQLitePeerMacro.self,
    ]
}

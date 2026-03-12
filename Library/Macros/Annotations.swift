//
//  Annotations.swift
//  SundeedQLite
//
//  Created by SundeedQLite on 2026.
//  Copyright © 2026 LUMBERCODE. All rights reserved.
//

import Foundation

// MARK: - Macro Declaration

/// Attached macro that auto-generates `sundeedQLiterMapping(map:)`, `init()`,
/// and `SundeedQLiter` conformance for the annotated class.
///
/// Usage:
/// ```swift
/// @SundeedQLiteModel
/// class Employee {
///     @Primary var id: String!
///     var name: String?
///     @Ignore var transientField: Int = 0
/// }
/// ```
///
/// The macro expands to produce the same operator-based mapping code that
/// you would write by hand, ensuring full backward compatibility with the
/// existing `SundeedQLiter` runtime.
@attached(member, names: named(init), named(sundeedQLiterMapping))
@attached(extension, conformances: SundeedQLiter)
public macro SundeedQLiteModel() = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLiteModelMacro"
)

// MARK: - Property Annotations

/// Ordering direction for `@Ordered` annotation.
public enum SundeedQLiteOrder: String, Sendable {
    case ascending
    case descending
}

/// Marks a property as the primary key for the model.
///
/// Only one property per class can be marked `@Primary`.
/// Equivalent to the `+` postfix operator on `SundeedQLiteMap`.
@attached(peer)
public macro Primary() = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

/// Marks a property as the ordering column for the model.
///
/// Only one property per class can be marked `@Ordered`.
/// Equivalent to `<<` (ascending) or `>>` (descending) postfix operators.
@attached(peer)
public macro Ordered(_ direction: SundeedQLiteOrder = .ascending) = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

/// Marks a property as mandatory — if the value is nil during deserialization,
/// the entire object is rejected (`isSafeToAdd = false`).
///
/// Equivalent to the `<*>` operator.
@attached(peer)
public macro Mandatory() = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

/// Marks an array property of `SundeedQLiter` objects as mandatory —
/// if the array is empty during deserialization, the entire object is rejected.
///
/// **Only valid on arrays of `SundeedQLiter`-conforming types.**
/// Applying this to primitive arrays (e.g., `[String]`) will produce a compile-time error.
///
/// Equivalent to the `<**>` operator.
@attached(peer)
public macro MandatoryArray() = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

/// Overrides the default column name for the property.
///
/// By default, the property name is used as the column name.
/// Use `@Column("custom_name")` to map to a different database column.
@attached(peer)
public macro Column(_ name: String) = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

/// Specifies a `SundeedQLiteConverter` type for custom type bridging.
///
/// The converter must conform to `SundeedQLiteConverter` and have an
/// accessible `init()`. The macro generates `(map["key"], ConverterType())`
/// tuple syntax for the mapping.
@attached(peer)
public macro Converted(_ converter: Any.Type) = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

/// Excludes a property from the database mapping entirely.
///
/// Use this for transient, computed, or UI-only properties that should
/// not be persisted to SQLite.
@attached(peer)
public macro Ignore() = #externalMacro(
    module: "SundeedQLiteMacrosPlugin",
    type: "SundeedQLitePeerMacro"
)

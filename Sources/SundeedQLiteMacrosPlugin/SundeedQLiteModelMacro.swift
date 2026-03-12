//
//  SundeedQLiteModelMacro.swift
//  SundeedQLiteMacros
//
//  Created by SundeedQLite on 2026.
//  Copyright © 2026 LUMBERCODE. All rights reserved.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

// MARK: - Diagnostic Messages

enum SundeedQLiteDiagnostic: String, DiagnosticMessage {
    case classOnly = "@SundeedQLiteModel can only be applied to classes"
    case multiplePrimaryKeys = "Only one property can be marked with @Primary"
    case multipleOrderedColumns = "Only one property can be marked with @Ordered"
    case mandatoryOnNonOptional = "@Mandatory can only be applied to optional properties"
    case mandatoryArrayOnNonSundeedQLiter = "@MandatoryArray can only be applied to arrays of SundeedQLiter-conforming types, not primitive arrays"
    case mandatoryAndMandatoryArray = "@Mandatory and @MandatoryArray cannot be applied to the same property"
    case convertedWithMandatoryArray = "@Converted cannot be combined with @MandatoryArray"

    var message: String { rawValue }
    var diagnosticID: MessageID {
        MessageID(domain: "SundeedQLiteMacros", id: rawValue)
    }
    var severity: DiagnosticSeverity { .error }
}

// MARK: - Property Metadata

/// Represents parsed metadata for a single stored property.
struct PropertyInfo {
    let name: String
    let typeSyntax: TypeSyntax
    let typeString: String
    let isPrimary: Bool
    let ordered: OrderInfo?
    let isMandatory: Bool
    let isMandatoryArray: Bool
    let columnName: String
    let converterType: String?
    let isIgnored: Bool
    let node: DeclSyntaxProtocol

    struct OrderInfo {
        let ascending: Bool
    }
}

// MARK: - Type Classification

/// Classifies a Swift type string for the code generator.
enum TypeCategory {
    case sundeedQLiter          // T: SundeedQLiter
    case sundeedQLiterArray     // [T] where T: SundeedQLiter (any optionality variant)
    case converter              // Uses a SundeedQLiteConverter
    case primitive              // String, Int, Double, Float, Bool, Date, Data, UIImage
    case primitiveArray         // [String], [Int], etc.
    case unknown
}

// MARK: - Macro Implementation

public struct SundeedQLiteModelMacro {}

extension SundeedQLiteModelMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Validate: must be a class
        guard declaration.is(ClassDeclSyntax.self) else {
            context.diagnose(Diagnostic(
                node: node,
                message: SundeedQLiteDiagnostic.classOnly
            ))
            return []
        }

        // Parse all stored properties
        let properties = parseProperties(from: declaration, in: context)

        // Validate constraints
        let primaryCount = properties.filter { $0.isPrimary }.count
        if primaryCount > 1 {
            context.diagnose(Diagnostic(
                node: node,
                message: SundeedQLiteDiagnostic.multiplePrimaryKeys
            ))
            return []
        }

        let orderedCount = properties.filter { $0.ordered != nil }.count
        if orderedCount > 1 {
            context.diagnose(Diagnostic(
                node: node,
                message: SundeedQLiteDiagnostic.multipleOrderedColumns
            ))
            return []
        }

        // Generate members
        let initDecl = generateInit()
        let mappingDecl = generateMappingFunction(properties: properties)

        return [initDecl, mappingDecl]
    }
}

extension SundeedQLiteModelMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // Only add conformance if not already declared
        let ext: DeclSyntax = """
        extension \(type.trimmed): SundeedQLiter {}
        """
        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

// MARK: - Peer Macro (No-op, just for annotation)

/// Peer macro that does nothing — annotations are read by the member macro.
public struct SundeedQLitePeerMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return []
    }
}

// MARK: - Property Parsing

extension SundeedQLiteModelMacro {
    static func parseProperties(
        from declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) -> [PropertyInfo] {
        var properties: [PropertyInfo] = []

        for member in declaration.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                  varDecl.bindingSpecifier.tokenKind == .keyword(.var) else {
                continue
            }

            // Skip computed properties (has `get` accessor).
            // Stored properties with `willSet`/`didSet` don't have `get`,
            // so they're correctly included.
            if let binding = varDecl.bindings.first {
                if case .getter = binding.accessorBlock?.accessors {
                    continue
                }
                if let accessorList = binding.accessorBlock?.accessors,
                   case .accessors(let accessors) = accessorList {
                    let hasGetter = accessors.contains { accessor in
                        accessor.accessorSpecifier.tokenKind == .keyword(.get)
                    }
                    if hasGetter {
                        continue
                    }
                }
            }

            guard let binding = varDecl.bindings.first,
                  let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                  let typeAnnotation = binding.typeAnnotation else {
                continue
            }

            let propertyName = pattern.identifier.text
            let typeSyntax = typeAnnotation.type
            let typeString = typeSyntax.trimmedDescription

            // Parse attributes
            let attrs = varDecl.attributes
            let isIgnored = hasAttribute(named: "Ignore", in: attrs)
            if isIgnored {
                properties.append(PropertyInfo(
                    name: propertyName,
                    typeSyntax: typeSyntax,
                    typeString: typeString,
                    isPrimary: false,
                    ordered: nil,
                    isMandatory: false,
                    isMandatoryArray: false,
                    columnName: propertyName,
                    converterType: nil,
                    isIgnored: true,
                    node: varDecl
                ))
                continue
            }

            let isPrimary = hasAttribute(named: "Primary", in: attrs)
            let isMandatory = hasAttribute(named: "Mandatory", in: attrs)
            let isMandatoryArray = hasAttribute(named: "MandatoryArray", in: attrs)
            let columnName = extractColumnName(from: attrs) ?? propertyName
            let converterType = extractConverterType(from: attrs)
            let ordered = extractOrdered(from: attrs)

            // Validate: @Mandatory and @MandatoryArray are mutually exclusive
            if isMandatory && isMandatoryArray {
                context.diagnose(Diagnostic(
                    node: Syntax(varDecl),
                    message: SundeedQLiteDiagnostic.mandatoryAndMandatoryArray
                ))
                continue
            }

            // Validate: @MandatoryArray only on SundeedQLiter arrays
            if isMandatoryArray {
                let strippedType = stripAllOptionality(typeString)
                let innerType = extractArrayInnerType(strippedType)
                if innerType == nil || isPrimitiveType(innerType!) {
                    context.diagnose(Diagnostic(
                        node: Syntax(varDecl),
                        message: SundeedQLiteDiagnostic.mandatoryArrayOnNonSundeedQLiter
                    ))
                    continue
                }
            }

            // Validate: @Converted cannot be combined with @MandatoryArray
            if converterType != nil && isMandatoryArray {
                context.diagnose(Diagnostic(
                    node: Syntax(varDecl),
                    message: SundeedQLiteDiagnostic.convertedWithMandatoryArray
                ))
                continue
            }

            properties.append(PropertyInfo(
                name: propertyName,
                typeSyntax: typeSyntax,
                typeString: typeString,
                isPrimary: isPrimary,
                ordered: ordered,
                isMandatory: isMandatory,
                isMandatoryArray: isMandatoryArray,
                columnName: columnName,
                converterType: converterType,
                isIgnored: false,
                node: varDecl
            ))
        }

        return properties
    }

    // MARK: - Attribute Helpers

    static func hasAttribute(named name: String, in attributes: AttributeListSyntax) -> Bool {
        for attr in attributes {
            if let attribute = attr.as(AttributeSyntax.self),
               let identifier = attribute.attributeName.as(IdentifierTypeSyntax.self),
               identifier.name.text == name {
                return true
            }
        }
        return false
    }

    static func extractColumnName(from attributes: AttributeListSyntax) -> String? {
        for attr in attributes {
            if let attribute = attr.as(AttributeSyntax.self),
               let identifier = attribute.attributeName.as(IdentifierTypeSyntax.self),
               identifier.name.text == "Column",
               let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
               let firstArg = arguments.first,
               let stringLiteral = firstArg.expression.as(StringLiteralExprSyntax.self) {
                return stringLiteral.segments.trimmedDescription
            }
        }
        return nil
    }

    static func extractConverterType(from attributes: AttributeListSyntax) -> String? {
        for attr in attributes {
            if let attribute = attr.as(AttributeSyntax.self),
               let identifier = attribute.attributeName.as(IdentifierTypeSyntax.self),
               identifier.name.text == "Converted",
               let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
               let firstArg = arguments.first {
                // Handle MyConverter.self
                let exprText = firstArg.expression.trimmedDescription
                if exprText.hasSuffix(".self") {
                    return String(exprText.dropLast(5))
                }
                return exprText
            }
        }
        return nil
    }

    static func extractOrdered(from attributes: AttributeListSyntax) -> PropertyInfo.OrderInfo? {
        for attr in attributes {
            if let attribute = attr.as(AttributeSyntax.self),
               let identifier = attribute.attributeName.as(IdentifierTypeSyntax.self),
               identifier.name.text == "Ordered" {
                // Check arguments for direction
                if let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
                   let firstArg = arguments.first {
                    let exprText = firstArg.expression.trimmedDescription
                    if exprText.contains("descending") {
                        return PropertyInfo.OrderInfo(ascending: false)
                    }
                }
                // Default: ascending
                return PropertyInfo.OrderInfo(ascending: true)
            }
        }
        return nil
    }

    // MARK: - Type Helpers

    static let primitiveTypes: Set<String> = [
        "String", "Int", "Double", "Float", "Bool", "Date", "Data", "UIImage"
    ]

    static func isPrimitiveType(_ type: String) -> Bool {
        primitiveTypes.contains(stripAllOptionality(type))
    }

    /// Strips `?` and `!` (ImplicitlyUnwrappedOptional) from type strings.
    static func stripAllOptionality(_ type: String) -> String {
        var result = type.trimmingCharacters(in: .whitespaces)
        while result.hasSuffix("?") || result.hasSuffix("!") {
            result = String(result.dropLast())
        }
        return result
    }

    /// For `[Foo]`, `[Foo?]`, `[Foo]?`, `[Foo?]?` etc., extracts `Foo`.
    static func extractArrayInnerType(_ type: String) -> String? {
        let stripped = stripAllOptionality(type)
        guard stripped.hasPrefix("[") && stripped.hasSuffix("]") else {
            return nil
        }
        let inner = String(stripped.dropFirst().dropLast())
        return stripAllOptionality(inner)
    }

    /// Returns true if the type is an array type (after stripping optionality).
    static func isArrayType(_ type: String) -> Bool {
        let stripped = stripAllOptionality(type)
        return stripped.hasPrefix("[") && stripped.hasSuffix("]")
    }
}

// MARK: - Code Generation

extension SundeedQLiteModelMacro {
    static func generateInit() -> DeclSyntax {
        return """
        required init() {}
        """
    }

    static func generateMappingFunction(properties: [PropertyInfo]) -> DeclSyntax {
        var lines: [String] = []

        for prop in properties where !prop.isIgnored {
            let line = generateMappingLine(for: prop)
            lines.append(line)
        }

        let body = lines.joined(separator: "\n        ")

        return """
        func sundeedQLiterMapping(map: SundeedQLiteMap) {
                \(raw: body)
            }
        """
    }

    static func generateMappingLine(for prop: PropertyInfo) -> String {
        let mapAccess = generateMapAccess(for: prop)

        if prop.converterType != nil {
            return generateConverterLine(for: prop, mapAccess: mapAccess)
        } else if prop.isMandatoryArray {
            return "\(prop.name) <**> \(mapAccess)"
        } else if prop.isMandatory {
            return "\(prop.name) <*> \(mapAccess)"
        } else {
            return "\(prop.name) <~> \(mapAccess)"
        }
    }

    /// Generates the right-hand side: `map["columnName"]`, optionally with
    /// `+`, `<<`, or `>>` postfix operators.
    static func generateMapAccess(for prop: PropertyInfo) -> String {
        var access = "map[\"\(prop.columnName)\"]"

        if prop.isPrimary {
            access += "+"
        }

        if let ordered = prop.ordered {
            access += ordered.ascending ? "<<" : ">>"
        }

        return access
    }

    /// Generates converter-based mapping lines.
    /// `property <~> (map["key"], ConverterType())`
    /// or `property <*> (map["key"], ConverterType())`
    static func generateConverterLine(for prop: PropertyInfo, mapAccess: String) -> String {
        guard let converter = prop.converterType else { return "" }

        let operatorStr = prop.isMandatory ? "<*>" : "<~>"
        // For converter lines, the right-hand side is a tuple of (map["key"], Converter())
        // But the postfix operators (+, <<, >>) apply to the map before the tuple.
        // The tuple format is: (map["key"]+ , Converter()) — postfix is on the map subscript.
        return "\(prop.name) \(operatorStr) (\(mapAccess), \(converter)())"
    }
}

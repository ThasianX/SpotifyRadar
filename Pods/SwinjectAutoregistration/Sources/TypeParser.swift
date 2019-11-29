//
//  Parser.swift
//  SwinjectAutoregistration
//
//  Created by Tomas Kohout on 21/01/2017.
//  Copyright © 2017 Swinject Contributors. All rights reserved.
//

import Foundation
#if !os(Linux)
    extension Scanner {
        func scanString(_ string: String) -> String? {
            var value: NSString?
            if self.scanString(string, into: &value), let value = value {
                return value as String
            }
            return nil
        }
        
        func scanCharactersFromSet(_ set: CharacterSet) -> String? {
            var value: NSString?
            if self.scanCharacters(from: set, into: &value), let value = value {
                return value as String
            }
            return nil
        }
    }
    
    extension NSMutableCharacterSet {
        func insert(charactersIn range: Range<UnicodeScalar>) {
            let nsRange = NSRange(location: Int(range.lowerBound.value), length: Int(range.upperBound.value - range.lowerBound.value))
            self.addCharacters(in: nsRange)
        }
        
        func insert(charactersIn string: String) {
            self.addCharacters(in: string)
        }
        
        func formUnion(_ set: CharacterSet) {
            self.formUnion(with: set)
        }
    }
#endif



private func ..<(start: Int, end: Int) -> Range<UnicodeScalar> {
    return UnicodeScalar(start)! ..< UnicodeScalar(end)!
}

/// Simple top-down parser for type description based on swift grammatic:
/// See https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Types.html
///
/// type →
///  [-] array-type­ - Printed as Array<...>
///  [-] dictionary-type­ - Printed as Dictionary<...>
///  [x] function-type­ `tuple-type throws? -> type`
///  [x] type-identifier­ `identifier ­generic-argument-clause? .­ type-identifier?­`
///  [x] tuple-type­ `type,? type ...`
///  [-] optional-type­ - Printed as Optional<...>
///  [-] implicitly-unwrapped-optional-type­ - Printed as ImplicitlyUnwrappedOptional<...>
///  [x] protocol-composition-type­ `identifier & identifier ...`
///  [-] metatype-type­ - recognized by type identifier
///  [-] Any, Self - recognized by type identifier
///
///  [x] identifier → identifier-head ­identifier-characters?­
///  [-] identifier → `­identifier-head­identifier-characters­?`­ - backticks are not printed
///  [-] identifier → implicit-parameter-name­ - e.g. $0, $1 - not needed in type
///  [x] identifier-list → identifier­ | identifier­,­identifier-list

class TypeParser {
    
    let scanner: Scanner
    
    init(string: String){
        scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = CharacterSet.whitespacesAndNewlines
    }
    
    func parseType() -> Type? {
        if let function = parseFunctionType() {
            return Type.closure(parameters: function.parameters, returnType: function.returnType, throws: function.throws)
        } else if let protocolComposition = parseProtocolCompositionClause() {
            return Type.protocolComposition(protocolComposition)
        } else if let typeIdentifier = parseTypeIdentifier() {
            return Type.identifier(typeIdentifier)
        } else if let tupleType = parseTupleType() {
            return Type.tuple(tupleType)
        }
        
        return nil
    }
    
    func parseTypeAnnotation() -> Type? {
        let originalLocation = scanner.scanLocation
        
        //Scan param name
        _ = parseIdentifier()
        
        //Return if param name is not specified
        if scanner.scanString(":") == nil {
            scanner.scanLocation = originalLocation
        }
        
        return parseType()
    }
    
    func parseTypeIdentifier() -> TypeIdentifier? {
        guard let typeName = parseIdentifier() else { return nil }
        
        let genericTypes = parseGenericArgumentClause() ?? []
        var subTypeIdentifier: TypeIdentifier? = nil
        
        if scanner.scanString(".") != nil, let typeIdentifier = parseTypeIdentifier() {
            subTypeIdentifier = typeIdentifier
        }
        
        return TypeIdentifier(name: typeName, genericTypes: genericTypes, subTypeIdentifier: subTypeIdentifier)
        
    }
    
    func parseGenericArgumentClause() -> [Type]? {
        guard scanner.scanString("<") != nil else { return nil }
        guard let type = parseType() else { return nil }
        
        var types: [Type] = [type]
        
        while scanner.scanString(",") != nil, let type = parseType(){
            types.append(type)
        }
        
        guard scanner.scanString(">") != nil else { return nil }
        return types
    }
    
    func parseProtocolCompositionClause() -> [TypeIdentifier]? {
        let originalLocation = scanner.scanLocation
        
        guard let protocolType = parseTypeIdentifier() else { return nil }
        
        var protocolTypes: [TypeIdentifier] = [protocolType]
        
        while scanner.scanString("&") != nil, let protocolType = parseTypeIdentifier() {
            protocolTypes.append(protocolType)
        }
        
        guard protocolTypes.count > 1 else { scanner.scanLocation = originalLocation; return nil; }
        
        return protocolTypes
    }
    
    func parseTupleType() -> [Type]? {
        guard scanner.scanString("(") != nil else { return nil }
        
        var types: [Type] = []
        
        if let type = parseTypeAnnotation() { types.append(type) }
        
        
        
        while scanner.scanString(",") != nil, let type = parseTypeAnnotation() {
            types.append(type)
        }
        
        guard scanner.scanString(")") != nil else { return nil }
        
        return types
    }
    
    func parseFunctionType() -> (parameters: [Type], returnType: Type, throws: Bool)? {
        let originalLocation = scanner.scanLocation
        
        guard let parameters = parseTupleType() else { return nil }
        
        let `throws` = scanner.scanString("throws") != nil
        // - rethrows is not allowed for closures
        
        guard scanner.scanString("->") != nil else { scanner.scanLocation = originalLocation; return nil }
        
        guard let returnType = parseType() else { scanner.scanLocation = originalLocation; return nil }
        
        return (parameters: parameters, returnType: returnType, throws: `throws`)
        
    }
    
    func parseIdentifier() -> String? {
        // See https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/swift/grammar/identifier-head
        
        //Identifier head
        #if os(Linux)
            var head = CharacterSet()
        #else
            let head = NSMutableCharacterSet()
        #endif
        head.formUnion(CharacterSet.letters)
        head.insert(charactersIn: "_")
        
        let ranges = [
            0x00A8 ..< 0x00A8, 0x00AA ..< 0x00AA,  0x00AD ..< 0x00AD, 0x00AF ..< 0x00AF, 0x00B2..<0x00B5, 0x00B7..<0x00BA,
            0x00BC..<0x00BE, 0x00C0..<0x00D6, 0x00D8..<0x00F6, 0x00F8..<0x00FF,
            0x0100..<0x02FF, 0x0370..<0x167F, 0x1681..<0x180D, 0x180F..<0x1DBF,
            0x1E00..<0x1FFF,
            0x200B..<0x200D, 0x202A..<0x202E, 0x203F..<0x2040, 0x2054..<0x2054, 0x2060..<0x206F,
            0x2070..<0x20CF, 0x2100..<0x218F, 0x2460..<0x24FF, 0x2776..<0x2793,
            0x2C00..<0x2DFF, 0x2E80..<0x2FFF,
            0x3004..<0x3007, 0x3021..<0x302F, 0x3031..<0x303F, 0x3040..<0xD7FF,
            0xF900..<0xFD3D, 0xFD40..<0xFDCF, 0xFDF0..<0xFE1F, 0xFE30..<0xFE44,
            0xFE47..<0xFFFD,
            //Emoticons
            0x10000..<0x1FFFD, 0x20000..<0x2FFFD, 0x30000..<0x3FFFD, 0x40000..<0x4FFFD,
            0x50000..<0x5FFFD, 0x60000..<0x6FFFD, 0x70000..<0x7FFFD, 0x80000..<0x8FFFD,
            0x90000..<0x9FFFD, 0xA0000..<0xAFFFD, 0xB0000..<0xBFFFD, 0xC0000..<0xCFFFD,
            0xD0000..<0xDFFFD, 0xE0000..<0xEFFFD]
        
        ranges.forEach { head.insert(charactersIn: $0) }
        
        //Identifier characters
        #if os(Linux)
            var characters = head
        #else
            let characters = head.copy() as! NSMutableCharacterSet
        #endif
        characters.insert(charactersIn: "0123456789")
        
        
        let charactersRanges =  [0x0300..<0x036F, 0x1DC0..<0x1DFF, 0x20D0..<0x20FF, 0xFE20..<0xFE2F]
        charactersRanges.forEach { characters.insert(charactersIn: $0) }
        
        guard let headString = scanner.scanCharactersFromSet(head as CharacterSet) else { return nil }
        
        let charactersString = scanner.scanCharactersFromSet(characters as CharacterSet)
        return "\(headString)\(charactersString ?? "")"
    }
    
}

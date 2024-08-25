import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

public enum NavigatableMacro {}

extension NavigatableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let routeNavigatableExtension = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): Navigatable {}
            """
        )
        
        return [
            routeNavigatableExtension,
        ]
    }
}

extension NavigatableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.structRequired
        }
        let modifier = if let modifier = structDecl.modifiers.first {
            modifier.name.trimmed
        } else {
            TokenSyntax.keyword(.internal)
        }
        let navigatorMember = DeclSyntax(stringLiteral: "@EnvironmentObject \(modifier) var navigator: Navigator")
        return [
            navigatorMember,
        ]
    }
}

enum MacroError: Error {
    case structRequired
}

@main
struct NavigatableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        NavigatableMacro.self,
    ]
}

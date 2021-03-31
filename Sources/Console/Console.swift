//
//  Console.swift
//  
//
//  Created by Pascal van der Locht on 30.03.21.
//

import Foundation

public struct Console {
    let baseIndent: Int
    private let currentIndent: Int
    let color: Color

    private let messages: [Message]

    public init(baseIndent: Int = 2, color: Color = .default) {
        self.baseIndent = baseIndent
        self.currentIndent = 0
        self.color = color
        self.messages = []
    }

    private init(baseIndent: Int, currentIndent: Int, color: Color, messages: [Message]) {
        self.baseIndent = baseIndent
        self.currentIndent = currentIndent
        self.color = color
        self.messages = messages
    }

    private func copy(currentIndent: Int? = nil, color: Color? = nil, messages: [Message]? = nil) -> Self {
        Console(baseIndent: self.baseIndent, currentIndent: currentIndent ?? self.currentIndent, color: color ?? self.color, messages: messages ?? self.messages)
    }

    public func indent(_ block: (Console) -> Console) -> Console {
        return block(self.indented()).copy(currentIndent: self.currentIndent)

    }

    public func colored(with color: Color, _ block: (Console) -> Console) -> Self {
        return block(self.colored(with: color)).copy(color: self.color)
    }

    public func print(_ string: String, seperator: String = " ", terminator: String = "\n") -> Self {
        return self.copy(messages: messages + [Message(color: self.color, indent: self.currentIndent, text: string, seperator: seperator, terminator: terminator)])
    }

    public func run(with printFunction: (String, String, String) -> Void) {
        self.messages
            .forEach { message in
                printFunction(message.message(), message.seperator, message.terminator)
            }
    }

    func indented() -> Console {
        self.copy(currentIndent: self.currentIndent + baseIndent)
    }

    func colored(with color: Color) -> Console {
        self.copy(color: color)
    }
}

extension Console {

    static func indented(_ console: Console) -> Console {
        console.indented()
    }

    static func colored(_ console: Console, with color: Color) -> Console {
        console.colored(with: color)
    }


}

extension Console {
    private struct Message {
        let color: Color
        let indent: Int
        let text: String
        let seperator: String
        let terminator: String

        private func createIndentString(for indent: Int) -> String {
            Array(repeating: " ", count: indent)
                .reduce("", +)
        }

        private func createColorPrefix(for color: Color) -> String {
            "\u{001B}\(color.rawValue)"
        }

        func message() -> String {
            createColorPrefix(for: self.color) + self.createIndentString(for: self.indent) + self.text + self.createColorPrefix(for: .default)
        }
    }
}

extension Console {
    func mergingMessages(from other: Console) -> Console {
        self.copy(messages: self.messages + other.messages)
    }
}

public func print(_ message: String, separator: String, terminator: String) {
    Swift.print(message, separator: separator, terminator: terminator)
}

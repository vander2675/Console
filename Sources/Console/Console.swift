//
//  Console.swift
//  
//
//  Created by Pascal van der Locht on 30.03.21.
//

import Foundation

public struct Console {
    var baseIndent: Int
    private let currentIndent: Int
    var color: Color

    private var messages: [Message]

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
            .reduce(into: [(String, String, String)]()) { array, message in
                array.append((message.message(isNewLine: (array.last?.2 ?? "\n") == "\n"), message.seperator, message.terminator))
            }
            .forEach { (message, seperator, terminator) in
                printFunction(message, seperator, terminator)
            }
    }

    public func indented() -> Console {
        self.copy(currentIndent: self.currentIndent + baseIndent)
    }

    public func colored(with color: Color) -> Console {
        self.copy(color: color)
    }

    public func empty() -> Console {
        self.copy(messages: [])
    }
}

// MARK: - Mutating
extension Console {

    public mutating func print(_ string: String, seperator: String = " ", terminator: String = "\n") {
        self.messages.append(Message(color: self.color, indent: self.currentIndent, text: string, seperator: seperator, terminator: terminator))
    }

}

extension Console {

    public static func indented(_ console: Console) -> Console {
        console.indented()
    }

    public static func colored(_ console: Console, with color: Color) -> Console {
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

        var endsLine: Bool {
            terminator == "\n"
        }

        private func createIndentString(for indent: Int) -> String {
            Array(repeating: " ", count: indent)
                .reduce("", +)
        }

        private func createColorPrefix(for color: Color) -> String {
            "\u{001B}\(color.rawValue)"
        }

        func message(isNewLine: Bool) -> String {
            createColorPrefix(for: self.color) + (isNewLine ? self.createIndentString(for: self.indent) : "") + self.text + self.createColorPrefix(for: .default)
        }
    }
}

extension Console {
    public func mergingMessages(from other: Console) -> Console {
        self.copy(messages: self.messages + other.messages)
    }
}

public func print(_ message: String, separator: String, terminator: String) {
    Swift.print(message, separator: separator, terminator: terminator)
}

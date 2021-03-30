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

    public init(baseIndent: Int = 2, color: Color = .default) {
        self.baseIndent = baseIndent
        self.currentIndent = 0
        self.color = color
    }

    private init(baseIndent: Int, currentIndent: Int, color: Color) {
        self.baseIndent = baseIndent
        self.currentIndent = currentIndent
        self.color = color
    }

    private func copy(currentIndent: Int? = nil, color: Color? = nil) -> Self {
        Console(baseIndent: self.baseIndent, currentIndent: currentIndent ?? self.currentIndent, color: color ?? self.color)
    }

    @discardableResult
    public func indent(_ block: (Console) -> Void) -> Console {
        block(self.copy(currentIndent: currentIndent + baseIndent))
        return self
    }

    @discardableResult
    public func colored(with color: Color, _ block: (Console) -> Void) -> Self {
        block(self.copy(color: color))
        return self
    }

    private func createIndentString() -> String {
        Array(repeating: " ", count: currentIndent)
            .reduce("", +)
    }

    private func createColorPrefix(for color: Color) -> String {
        "\u{001B}\(color.rawValue)"
    }

    @discardableResult
    public func print(_ string: String, seperator: String = " ", terminator: String = "\n") -> Self {
        Swift.print(createColorPrefix(for: self.color) + createIndentString() + string + createColorPrefix(for: .default), separator: seperator, terminator: terminator)
        return self
    }
}

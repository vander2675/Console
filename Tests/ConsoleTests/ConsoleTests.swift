import XCTest
@testable import Console

final class ConsoleTests: XCTestCase {

    func testOutput() {

        let base = Console()

        base
            .print("Base Level")
            .indent {
                $0
                    .print("Level 1")
                    .indent {
                        $0
                            .print("Level2")
                    }
                    .print("Level 1 again")
            }
            .print("Base Level again")
            .run(with: print)

    }

    func testColoredOutput() {
        Console()
            .colored(with: .red) {
                $0
                    .print("This should be red")
                    .print("Another red Line")
            }
            .colored(with: .green) {
                $0
                    .print("And this one is green")
            }
            .run(with: print)
    }

    func testNotEndingLine() {

        Console()
            .indent {
                $0
                    .print("There should be no newline or indent ", terminator: "")
                    .print("here")
                    .print("But this should be on a new Line")
            }

            .run(with: print)


    }

    static var allTests = [
        ("testOutput", testOutput),
        ("testColoredOutput", testColoredOutput),
        ("testNotEndingLine", testNotEndingLine)
    ]
}

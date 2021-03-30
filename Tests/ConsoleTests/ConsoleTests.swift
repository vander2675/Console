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

    }

    func testColoredOutput() {
        Console()
            .print("")
            .colored(with: .red) {
                $0
                    .print("This should be red")
            }
    }

    static var allTests = [
        ("testOutput", testOutput),
        ("testColoredOutput", testColoredOutput)
    ]
}

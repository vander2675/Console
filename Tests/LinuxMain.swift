import XCTest

import ConsoleTests

var tests = [XCTestCaseEntry]()
tests += ConsoleTests.allTests()
XCTMain(tests)

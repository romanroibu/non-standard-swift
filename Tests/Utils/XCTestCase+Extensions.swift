import XCTest

extension XCTestCase {

    public func wait(for duration: TimeInterval) {

        // See: https://stackoverflow.com/a/42222302/1271958

        let waitExpectation = expectation(description: "Waiting")

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}

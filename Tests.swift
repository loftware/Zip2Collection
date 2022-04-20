import XCTest
import LoftDataStructures_Zip2Collection
import LoftTest_StandardLibraryProtocolChecks

extension Zip2Collection: RandomAccessCollectionAdapter {
  public typealias Base = Base0
}

final class Zip2CollectionTests: XCTestCase {
  func test0_0() {
    checkZip(0, 0)
  }

  func test0_1() {
    checkZip(0, 1)
  }

  func test0_2() {
    checkZip(0, 2)
  }

  func test1_0() {
    checkZip(1, 0)
  }

  func test1_1() {
    checkZip(1, 1)
  }

  func test1_2() {
    checkZip(1, 2)
  }

  func test2_0() {
    checkZip(2, 0)
  }

  func test2_1() {
    checkZip(2, 1)
  }

  func test2_2() {
    checkZip(2, 2)
  }

  func checkZip(_ n0: Int, _ n1: Int) {
    let expected = Array(Swift.zip(0..<n0, 0..<n1))
    do {
      let base0 = RandomAccessOperationCounter(0..<n0)
      let base1 = RandomAccessOperationCounter(0..<n1)
      let testSubject = Zip2Collection(base0, base1)

      testSubject.checkRandomAccessCollectionLaws(
        expecting: expected,
        operationCounts: base0.operationCounts,
        areEquivalent: ==
      )
    }

    do {
      let base0 = RandomAccessOperationCounter(0..<n0)
      let base1 = RandomAccessOperationCounter(0..<n1)
      let testSubject = Zip2Collection(base0, base1)

      testSubject.checkRandomAccessCollectionLaws(
        expecting: expected,
        operationCounts: base1.operationCounts,
        areEquivalent: ==
      )
    }

    // Check heterogeneous case
    let expected2 = Array(Swift.zip(0..<n0, 0...n1))
    zip(0..<n0, 0...n1)
      .checkBidirectionalCollectionLaws(
        expecting: expected2, areEquivalent: ==)

    var subject = zip(Array(0..<n0), Array(0...n1))
    subject.checkMutableCollectionLaws(
      expecting: expected2,
      writing: expected2.lazy.map { (a, b) in (a + 10, b + 20) },
      areEquivalent: ==
    )
  }

  func testEnumerated() {
    "Fox".enumerated()
      .checkCollectionLaws(expecting: [(0, "F"), (1, "o"), (2, "x")], areEquivalent: ==)

    Array("Fox").enumerated()
      .checkBidirectionalCollectionLaws(
        expecting: [(0, "F"), (1, "o"), (2, "x")], areEquivalent: ==)
  }
}

// Local Variables:
// fill-column: 100
// End:

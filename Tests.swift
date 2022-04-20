import XCTest
import LoftDataStructures_Zip2Collection
import LoftTest_StandardLibraryProtocolChecks

extension Zip2Collection: RandomAccessCollectionAdapter {
    public typealias Base = Base0
}

final class Zip2CollectionTests: XCTestCase {
  func checkZipConformances(length0 n0: Int, length1 n1: Int) {
    let expected = Swift.zip(0..<n0, 0..<n1).map(Pair.init)
    do {
      let base0 = RandomAccessOperationCounter(0..<n0)
      let base1 = RandomAccessOperationCounter(0..<n1)
      let testSubject = Zip2Collection(base0, base1)

      testSubject.checkRandomAccessCollectionLaws(
        expecting: expected,
        operationCounts: base0.operationCounts
      )
    }

    do {
      let base0 = RandomAccessOperationCounter(0..<n0)
      let base1 = RandomAccessOperationCounter(0..<n1)
      let testSubject = Zip2Collection(base0, base1)

      testSubject.checkRandomAccessCollectionLaws(
        expecting: expected,
        operationCounts: base1.operationCounts
      )
    }

    // Check heterogeneous case
    zip(0..<n0, 0...n1)
      .checkBidirectionalCollectionLaws(expecting: Swift.zip(0..<n0, 0...n1).map(Pair.init))

    var subject = zip(Array(0..<n0), Array(0...n1))
    subject.checkMutableCollectionLaws(
      expecting: Swift.zip(0..<n0, 0...n1).map(Pair.init),
      writing: Swift.zip(10..<n0 + 10, 20...(n1 + 20)).map(Pair.init))
  }

  func test_0_0() {
    checkZipConformance(length0: 0, length1: 0)
  }

  func test_0_1() {
    checkZipConformance(length0: 0, length1: 1)
  }

  func test_0_2() {
    checkZipConformance(length0: 0, length1: 2)
  }

  func test_1_0() {
    checkZipConformance(length0: 1, length1: 0)
  }

  func test_1_1() {
    checkZipConformance(length0: 1, length1: 1)
  }

  func test_1_2() {
    checkZipConformance(length0: 1, length1: 2)
  }

  func test_2_0() {
    checkZipConformance(length0: 2, length1: 0)
  }

  func test_2_1() {
    checkZipConformance(length0: 2, length1: 1)
  }

  func test_2_2() {
    checkZipConformance(length0: 2, length1: 2)
  }
}

// Local Variables:
// fill-column: 100
// End:

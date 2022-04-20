import XCTest
import LoftDataStructures_Zip2Collection
import LoftTest_StandardLibraryProtocolChecks

extension Zip2Collection: RandomAccessCollectionAdapter {
    public typealias Base = Base0
}

final class Zip2CollectionTests: XCTestCase {
  func test0_0() {
    checkConformances(0, 0)
  }

  func test0_1() {
    checkConformances(0, 1)
  }

  func test0_2() {
    checkConformances(0, 2)
  }

  func test1_0() {
    checkConformances(1, 0)
  }

  func test1_1() {
    checkConformances(1, 1)
  }

  func test1_2() {
    checkConformances(1, 2)
  }

  func test2_0() {
    checkConformances(2, 0)
  }

  func test2_1() {
    checkConformances(2, 1)
  }

  func test2_2() {
    checkConformances(2, 2)
  }

  func checkConformances(_ n0: Int, _ n1: Int) {
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
}


// Local Variables:
// fill-column: 100
// End:

import XCTest
import LoftDataStructures_Zip2Collection
import LoftTest_StandardLibraryProtocolChecks

final class Zip2CollectionTests: XCTestCase {
  func testZipConformances() {
    for n0 in 0...5 {
      for n1 in 0...5 {
        do {
          let base0 = RandomAccessOperationCounter(0...n0)
          let base1 = 0..<(n1 + 1)
          let testSubject = Zip2Collection(base0: base0, base1: base1)

          testSubject.checkRandomAccessCollectionLaws(
            expecting: Swift.zip2(base0, base1),
            operationCounts: base0.operationCounts
          )
        }

        do {
          let base0 = 0...n0
          let base1 = RandomAccessOperationCounter(0..<(n1 + 1))
          let testSubject = Zip2Collection(base0: base0, base1: base1)

          testSubject.checkRandomAccessCollectionLaws(
            expecting: Swift.zip2(base0, base1),
            operationCounts: base1.operationCounts
          )
        }
      }
    }
  }
}

// Local Variables:
// fill-column: 100
// End:

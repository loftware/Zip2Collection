public struct Zip2Collection<Base0: Collection, Base1: Collection>: Collection {
  public var base0: Base0
  public var base1: Base1

  public func makeIterator() -> Zip2Sequence<Base0, Base1>.Iterator {
    zip(base0, base1).makeIterator()
  }

  public struct Index: Comparable {
    public fileprivate(set) var base0: Base0.Index
    public fileprivate(set) var base1: Base1.Index

    public static func == (l: Self, r: Self) -> Bool {
      l.base0 == r.base0 || l.base1 == r.base1
    }

    public static func < (l: Self, r: Self) -> Bool {
      l.base0 < r.base0 && l.base1 < r.base1
    }
  }

  public typealias Element = (Base0.Element, Base1.Element)

  public subscript(i: Index) -> Element {
    get { (base0[i.base0], base1[i.base1]) }
  }

  public func index(after i: Index) -> Index {
    Index(base0: base0.index(after: i.base0), base1: base1.index(after: i.base1))
  }

  public func formIndex(after i: inout Index) {
    base0.formIndex(after: &i.base0)
    base1.formIndex(after: &i.base1)
  }

  public var startIndex: Index { Index(base0: base0.startIndex, base1: base1.startIndex)  }
  public var endIndex: Index { Index(base0: base0.endIndex, base1: base1.endIndex)  }
}

extension Zip2Collection: MutableCollection where Base0: MutableCollection, Base1: MutableCollection
{
  public subscript(i: Index) -> Element {
    get { (base0[i.base0], base1[i.base1]) }
    set { base0[i.base0] = newValue.0; base1[i.base1] = newValue.1 }
  }
}

extension Zip2Collection: RandomAccessCollection, BidirectionalCollection
  where Base0: RandomAccessCollection, Base1: RandomAccessCollection
{
  public var count: Int { Swift.min(base0.count, base1.count) }

  public func formIndex(i: inout Index, offsetBy n: Int) {
    defer {
      base0.formIndex(&i.base0, offsetBy: n)
      base1.formIndex(&i.base1, offsetBy: n)
    }

    if n >= 0 {
      _onFastPath();
      return
    }

    let lengthDifference = base1.count - base0.count
    if lengthDifference < 0 {
      if i.base1 == base1.endIndex {
        base1.formIndex(&i.base1, offsetBy: lengthDifference)
      }
      else if i.base0 == base0.endIndex {
        base0.formIndex(&i.base0, offsetBy: -lengthDifference)
      }
    }
  }

  public func index(_ i: Index, offsetBy n: Int) -> Index {
    var r = i
    formIndex(&r, offsetBy: n)
    return r
  }

  public func index(before i: Index) -> Index {
    var r = i
    formIndex(before: &r)
    return r
  }

  public func formIndex(before i: inout Index) {
    formIndex(&i, offsetBy: -1)
  }
}

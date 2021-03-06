private protocol Zip2RandomAccessCollection {
  func _normalize(_ ip: UnsafeMutableRawPointer)
}

public struct Zip2Collection<Base0: Collection, Base1: Collection> : Collection
{
  public var base0: Base0
  public var base1: Base1

  public init(_ base0: Base0, _ base1: Base1) {
    self.base0 = base0
    self.base1 = base1
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

  public var startIndex: Index {
    Index(base0: base0.startIndex, base1: base1.startIndex)
  }

  public var endIndex: Index {
    Index(base0: base0.endIndex, base1: base1.endIndex)
  }

  public func distance(from i: Index, to j: Index) -> Int {
    if i == j {
      return 0
    }
    else if i < j {
      return Swift.min(
        base0.distance(from: i.base0, to: j.base0),
        base1.distance(from: i.base1, to: j.base1))
    }
    else {
      return -Swift.min(
        base0.distance(from: j.base0, to: i.base0),
        base1.distance(from: j.base1, to: i.base1))

    }
  }

  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if n < 0, i == endIndex, let me = self as? Zip2RandomAccessCollection {
      me._normalize(&i)
    }
    else { _onFastPath() }

    base0.formIndex(&i.base0, offsetBy: n)
    base1.formIndex(&i.base1, offsetBy: n)
  }

  public func formIndex(_ i: inout Index, offsetBy n: Int, limitedBy l: Index) -> Bool {
    var l1 = l
    if i == endIndex, let me = self as? Zip2RandomAccessCollection {
      me._normalize(&i)
      me._normalize(&l1)
    }
    else { _onFastPath() }

    let r0 = base0.formIndex(&i.base0, offsetBy: n, limitedBy: l1.base0)
    let r1 = base1.formIndex(&i.base1, offsetBy: n, limitedBy: l1.base1)
    assert(r0 == r1)
    return r1
  }

  public func index(_ i: Index, offsetBy n:Int) -> Index {
    var r = i
    formIndex(&r, offsetBy: n)
    return r
  }

  public func index(_ i: Index, offsetBy n:Int, limitedBy l: Index) -> Index? {
    var p = i
    let success = formIndex(&p, offsetBy: n, limitedBy: l)
    return success ? p : nil
  }

  public var count: Int { Swift.min(base0.count, base1.count) }
}

extension Zip2Collection: MutableCollection where Base0: MutableCollection, Base1: MutableCollection
{
  public subscript(i: Index) -> Element {
    get { (base0[i.base0], base1[i.base1]) }
    set { base0[i.base0] = newValue.0; base1[i.base1] = newValue.1 }
  }
}


extension Zip2Collection
  : RandomAccessCollection, BidirectionalCollection, Zip2RandomAccessCollection
  where Base0: RandomAccessCollection, Base1: RandomAccessCollection
{
  public func index(before i: Index) -> Index {
    var r = i
    _normalize(&r)
    base0.formIndex(before: &r.base0)
    base1.formIndex(before: &r.base1)
    return r
  }

  fileprivate func _normalize(_ ip_: UnsafeMutableRawPointer) {
    let ip = ip_.assumingMemoryBound(to: Index.self)
    let lengthDifference = base1.count - base0.count
    if lengthDifference > 0 {
      if ip.pointee.base1 == base1.endIndex {
        base1.formIndex(&ip.pointee.base1, offsetBy: -lengthDifference)
      }
    }
    else {
      if ip.pointee.base0 == base0.endIndex {
        base0.formIndex(&ip.pointee.base0, offsetBy: lengthDifference)
      }
    }
  }
}

public func zip<C0: Collection, C1: Collection>(_ c0: C0, _ c1: C1) -> Zip2Collection<C0, C1> {
  Zip2Collection(c0, c1)
}

extension Collection {
  public func enumerated() -> Zip2Collection<Range<Int>, Self> {
    zip(0..<Int.max, self)
  }
}

// Local Variables:
// fill-column: 100
// End:

public struct Pair<T0, T1> {
  public var p0: T0
  public var p1: T1

  public init(_ p0: T0, _ p1: T1) {
    (self.p0, self.p1) = (p0, p1)
  }
}

extension Pair
  : RandomAccessCollection,
    BidirectionalCollection,
    Collection, Sequence, MutableCollection
  where T0 == T1
{
  public typealias Element = T0
  public typealias Index = Int

  public var startIndex: Int { 0 }
  public var endIndex: Int { 2 }

  public subscript(i: Int) -> T0 {
    get { return i == 0 ? p0 : p1 }
    set { if i == 0  { p0 = newValue } else { p1 = newValue } }
  }
}

extension Pair: Equatable where T0: Equatable, T1: Equatable {}
extension Pair: Hashable where T0: Hashable, T1: Hashable {}
extension Pair: Comparable where T0: Comparable, T1: Comparable {
  public static func <(l: Self, r: Self) -> Bool {
    return l.p0 < r.p0 ? true
      : l.p0 > r.p0 ? false
      : l.p1 < r.p1
  }
}

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

  public typealias Element = Pair<Base0.Element, Base1.Element>

  public subscript(i: Index) -> Element {
    get { .init(base0[i.base0], base1[i.base1]) }
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
    get { .init(base0[i.base0], base1[i.base1]) }
    set { base0[i.base0] = newValue.p0; base1[i.base1] = newValue.p1 }
  }
}


extension Zip2Collection
  : RandomAccessCollection, BidirectionalCollection, Zip2RandomAccessCollection
  where Base0: RandomAccessCollection, Base1: RandomAccessCollection
{
  public func index(before i: Index) -> Index {
    var r = i
    _formIndex(&r, negativeOffsetBy: -1)
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

  fileprivate func _formIndex(_ ip_: UnsafeMutableRawPointer, negativeOffsetBy n:Int) {
    assert(n < 0)
    let ip = ip_.assumingMemoryBound(to: Index.self)
    _normalize(&ip.pointee)
    base0.formIndex(&ip.pointee.base0, offsetBy: n)
    base1.formIndex(&ip.pointee.base1, offsetBy: n)
  }

  fileprivate func _formIndex(
    _ ip_: UnsafeMutableRawPointer, negativeOffsetBy n:Int, limitedBy lp_: UnsafeRawPointer) -> Bool
  {
    assert(n < 0)
    let ip = ip_.assumingMemoryBound(to: Index.self)
    let lp = lp_.assumingMemoryBound(to: Index.self)
    _normalize(&ip.pointee)
    let r0 = base0.formIndex(&ip.pointee.base0, offsetBy: n, limitedBy: lp.pointee.base0)
    let r1 = base1.formIndex(&ip.pointee.base1, offsetBy: n, limitedBy: lp.pointee.base1)
    assert(r0 == r1)
    return r1
  }
}

public func zip<C0: Collection, C1: Collection>(_ c0: C0, _ c1: C1) -> Zip2Collection<C0, C1> {
  Zip2Collection(c0, c1)
}

// Local Variables:
// fill-column: 100
// End:

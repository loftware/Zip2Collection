# `Zip2Collection`, `zip`, and `enumerated`

- Zip2Collection: A `Collection`-conforming version of `Zip2Sequence`:
  
  1. Requires that both bases conform to Collection.
  2. When both bases conform to `RandomAccessCollection`, `Zip2Sequence` does
     also.
  3. When both bases conform to `MutableCollection`, `Zip2Sequence` does also.

- `func zip<C0, C1>(_ x0: C0, _ x1: C1) -> Zip2Collection<C0, C1>` analogous to
  the `Zip2Sequence`-returning function in the standard library.

- `extension Collection { func enumerated() -> Zip2Sequence<Range<Int>, Element>
  }`, semantically equivalent to the standard library method on `Sequence` of
  the same name.
  


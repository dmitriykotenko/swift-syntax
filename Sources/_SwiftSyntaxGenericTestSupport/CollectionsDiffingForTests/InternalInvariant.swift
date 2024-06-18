//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

/// Internal checks.
///
/// Internal checks are to be used for checking correctness conditions in the
/// standard library. They are only enable when the standard library is built
/// with the build configuration INTERNAL_CHECKS_ENABLED enabled. Otherwise, the
/// call to this function is a noop.
@usableFromInline @_transparent
internal func _internalInvariant(
  _ condition: @autoclosure () -> Bool, _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
#if INTERNAL_CHECKS_ENABLED
  if !_fastPath(condition()) {
    _fatalErrorMessage("Fatal error", message, file: file, line: line,
                       flags: _fatalErrorFlags())
  }
#endif
}

// Only perform the invariant check on Swift 5.1 and later
@_alwaysEmitIntoClient // Swift 5.1
@_transparent
internal func _internalInvariant_5_1(
  _ condition: @autoclosure () -> Bool, _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
#if INTERNAL_CHECKS_ENABLED
  // FIXME: The below won't run the assert on 5.1 stdlib if testing on older
  // OSes, which means that testing may not test the assertion. We need a real
  // solution to this.
#if !$Embedded
  guard #available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *) //SwiftStdlib 5.1
  else { return }
#endif
  _internalInvariant(condition(), message, file: file, line: line)
#endif
}

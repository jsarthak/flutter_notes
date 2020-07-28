// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

// TODO(hmuller): should be device dependent.
/// The margin that a [FloatingActionButton] should leave between it and the
/// edge of the screen.
///
/// [FloatingActionButtonLocation.endFloat] uses this to set the appropriate margin
/// between the [FloatingActionButton] and the end of the screen.
const double kFloatingActionButtonMargin = 48.0;

/// The amount of time the [FloatingActionButton] takes to transition in or out.
///
/// The [Scaffold] uses this to set the duration of [FloatingActionButton]
/// motion, entrance, and exit animations.
const Duration kFloatingActionButtonSegue = Duration(milliseconds: 200);

/// The fraction of a circle the [FloatingActionButton] should turn when it enters.
///
/// Its value corresponds to 0.125 of a full circle, equivalent to 45 degrees or pi/4 radians.
const double kFloatingActionButtonTurnInterval = 0.125;

/// An object that defines a position for the [FloatingActionButton]
/// based on the [Scaffold]'s [ScaffoldPrelayoutGeometry].
///
/// Flutter provides [FloatingActionButtonLocation]s for the common
/// [FloatingActionButton] placements in Material Design applications. These
/// locations are available as static members of this class.
///
/// See also:
///
///  * [FloatingActionButton], which is a circular button typically shown in the
///    bottom right corner of the app.
///  * [FloatingActionButtonAnimator], which is used to animate the
///    [Scaffold.floatingActionButton] from one [FloatingActionButtonLocation] to
///    another.
///  * [ScaffoldPrelayoutGeometry], the geometry that
///    [FloatingActionButtonLocation]s use to position the [FloatingActionButton].
abstract class FABLocation {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const FABLocation();

  static const FloatingActionButtonLocation endDocked =
      _EndDockedFloatingActionButtonLocation();

  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry);

  @override
  String toString() => objectRuntimeType(this, 'FloatingActionButtonLocation');
}

double _leftOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  return kFloatingActionButtonMargin + scaffoldGeometry.minInsets.left - offset;
}

double _rightOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  return scaffoldGeometry.scaffoldSize.width -
      kFloatingActionButtonMargin -
      scaffoldGeometry.minInsets.right -
      scaffoldGeometry.floatingActionButtonSize.width +
      offset;
}

double _endOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  assert(scaffoldGeometry.textDirection != null);
  switch (scaffoldGeometry.textDirection) {
    case TextDirection.rtl:
      return _leftOffset(scaffoldGeometry, offset: offset);
    case TextDirection.ltr:
      return _rightOffset(scaffoldGeometry, offset: offset);
  }
  return null;
}

double _startOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  assert(scaffoldGeometry.textDirection != null);
  switch (scaffoldGeometry.textDirection) {
    case TextDirection.rtl:
      return _rightOffset(scaffoldGeometry, offset: offset);
    case TextDirection.ltr:
      return _leftOffset(scaffoldGeometry, offset: offset);
  }
  return null;
}

// Provider of common logic for [FloatingActionButtonLocation]s that
// dock to the [BottomAppBar].
abstract class _DockedFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const _DockedFloatingActionButtonLocation();

  // Positions the Y coordinate of the [FloatingActionButton] at a height
  // where it docks to the [BottomAppBar].
  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight / 2.0;
    // The FAB should sit with a margin between it and the snack bar.
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    // The FAB should sit with its center in front of the top of the bottom sheet.
    if (bottomSheetHeight > 0.0)
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return math.min(maxFabY, fabY);
  }
}

class _EndDockedFloatingActionButtonLocation
    extends _DockedFloatingActionButtonLocation {
  const _EndDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = _endOffset(scaffoldGeometry);
    return Offset(fabX, getDockedY(scaffoldGeometry));
  }

  @override
  String toString() => 'FloatingActionButtonLocation.endDocked';
}

abstract class FloatingActionButtonAnimator {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const FloatingActionButtonAnimator();

  /// Moves the [FloatingActionButton] by scaling out and then in at a new
  /// [FloatingActionButtonLocation].
  ///
  /// This animator shrinks the [FloatingActionButton] down until it disappears, then
  /// grows it back to full size at its new [FloatingActionButtonLocation].
  ///
  /// This is the default [FloatingActionButton] motion animation.
  static const FloatingActionButtonAnimator scaling =
      _ScalingFabMotionAnimator();

  /// Gets the [FloatingActionButton]'s position relative to the origin of the
  /// [Scaffold] based on [progress].
  ///
  /// [begin] is the [Offset] provided by the previous
  /// [FloatingActionButtonLocation].
  ///
  /// [end] is the [Offset] provided by the new
  /// [FloatingActionButtonLocation].
  ///
  /// [progress] is the current progress of the transition animation.
  /// When [progress] is 0.0, the returned [Offset] should be equal to [begin].
  /// when [progress] is 1.0, the returned [Offset] should be equal to [end].
  Offset getOffset(
      {@required Offset begin,
      @required Offset end,
      @required double progress});

  /// Animates the scale of the [FloatingActionButton].
  ///
  /// The animation should both start and end with a value of 1.0.
  ///
  /// For example, to create an animation that linearly scales out and then back in,
  /// you could join animations that pass each other:
  ///
  /// ```dart
  ///   @override
  ///   Animation<double> getScaleAnimation({@required Animation<double> parent}) {
  ///     // The animations will cross at value 0, and the train will return to 1.0.
  ///     return TrainHoppingAnimation(
  ///       Tween<double>(begin: 1.0, end: -1.0).animate(parent),
  ///       Tween<double>(begin: -1.0, end: 1.0).animate(parent),
  ///     );
  ///   }
  /// ```
  Animation<double> getScaleAnimation({@required Animation<double> parent});

  /// Animates the rotation of [Scaffold.floatingActionButton].
  ///
  /// The animation should both start and end with a value of 0.0 or 1.0.
  ///
  /// The animation values are a fraction of a full circle, with 0.0 and 1.0
  /// corresponding to 0 and 360 degrees, while 0.5 corresponds to 180 degrees.
  ///
  /// For example, to create a rotation animation that rotates the
  /// [FloatingActionButton] through a full circle:
  ///
  /// ```dart
  /// @override
  /// Animation<double> getRotationAnimation({@required Animation<double> parent}) {
  ///   return Tween<double>(begin: 0.0, end: 1.0).animate(parent);
  /// }
  /// ```
  Animation<double> getRotationAnimation({@required Animation<double> parent});

  /// Gets the progress value to restart a motion animation from when the animation is interrupted.
  ///
  /// [previousValue] is the value of the animation before it was interrupted.
  ///
  /// The restart of the animation will affect all three parts of the motion animation:
  /// offset animation, scale animation, and rotation animation.
  ///
  /// An interruption triggers if the [Scaffold] is given a new [FloatingActionButtonLocation]
  /// while it is still animating a transition between two previous [FloatingActionButtonLocation]s.
  ///
  /// A sensible default is usually 0.0, which is the same as restarting
  /// the animation from the beginning, regardless of the original state of the animation.
  double getAnimationRestart(double previousValue) => 0.0;

  @override
  String toString() => objectRuntimeType(this, 'FloatingActionButtonAnimator');
}

class _ScalingFabMotionAnimator extends FloatingActionButtonAnimator {
  const _ScalingFabMotionAnimator();

  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    if (progress < 0.5) {
      return begin;
    } else {
      return end;
    }
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    // Animate the scale down from 1 to 0 in the first half of the animation
    // then from 0 back to 1 in the second half.
    const Curve curve = Interval(0.5, 1.0, curve: Curves.ease);
    return _AnimationSwap<double>(
      ReverseAnimation(parent.drive(CurveTween(curve: curve.flipped))),
      parent.drive(CurveTween(curve: curve)),
      parent,
      0.5,
    );
  }

  // Because we only see the last half of the rotation tween,
  // it needs to go twice as far.
  static final Animatable<double> _rotationTween = Tween<double>(
    begin: 1.0 - kFloatingActionButtonTurnInterval * 2.0,
    end: 1.0,
  );

  static final Animatable<double> _thresholdCenterTween =
      CurveTween(curve: const Threshold(0.5));

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    // This rotation will turn on the way in, but not on the way out.
    return _AnimationSwap<double>(
      parent.drive(_rotationTween),
      ReverseAnimation(parent.drive(_thresholdCenterTween)),
      parent,
      0.5,
    );
  }

  // If the animation was just starting, we'll continue from where we left off.
  // If the animation was finishing, we'll treat it as if we were starting at that point in reverse.
  // This avoids a size jump during the animation.
  @override
  double getAnimationRestart(double previousValue) =>
      math.min(1.0 - previousValue, previousValue);
}

/// An animation that swaps from one animation to the next when the [parent] passes [swapThreshold].
///
/// The [value] of this animation is the value of [first] when [parent.value] < [swapThreshold]
/// and the value of [next] otherwise.
class _AnimationSwap<T> extends CompoundAnimation<T> {
  /// Creates an [_AnimationSwap].
  ///
  /// Both arguments must be non-null. Either can be an [_AnimationSwap] itself
  /// to combine multiple animations.
  _AnimationSwap(
      Animation<T> first, Animation<T> next, this.parent, this.swapThreshold)
      : super(first: first, next: next);

  final Animation<double> parent;
  final double swapThreshold;

  @override
  T get value => parent.value < swapThreshold ? first.value : next.value;
}

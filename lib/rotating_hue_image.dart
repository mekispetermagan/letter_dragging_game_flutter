import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Rotating hue filter effects for images.
// Two widget variants:
//
// - [StandaloneRotatingHueImage]:
//   Stateful image with its own ticker.
//
// - [RotatingHueImage]:
//   Stateless image used under a [RotatingHue] wrapper.



// helper function to compute hue rotation for image filtering
ColorFilter _hueRotation(double degrees) {
  final radians = degrees * pi / 180;
  final cosA = cos(radians);
  final sinA = sin(radians);

  // matrix for true hue rotation.
  return ColorFilter.matrix([
    0.213 + cosA * 0.787 - sinA * 0.213,
    0.715 - cosA * 0.715 - sinA * 0.715,
    0.072 - cosA * 0.072 + sinA * 0.928,
    0,
    0,
    0.213 - cosA * 0.213 + sinA * 0.143,
    0.715 + cosA * 0.285 + sinA * 0.140,
    0.072 - cosA * 0.072 - sinA * 0.283,
    0,
    0,
    0.213 - cosA * 0.213 - sinA * 0.787,
    0.715 - cosA * 0.715 + sinA * 0.715,
    0.072 + cosA * 0.928 + sinA * 0.072,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);
}


/// Image that animates its hue using an internal ticker.
/// Use this when you only need a single rotating image and don't
/// need to coordinate animation with other widgets.
class StandaloneRotatingHueImage extends StatefulWidget {
  final Image image;
  final double rotationSpeed;
  final double startingAngle;

  const StandaloneRotatingHueImage({
    required this.image,
    this.rotationSpeed = 10,
    this.startingAngle = 0,
    super.key,
  });

  @override
  State<StandaloneRotatingHueImage> createState() => _StandaloneRotatingHueImageState();
}

class _StandaloneRotatingHueImageState extends State<StandaloneRotatingHueImage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late double _angle;

  @override
  void initState() {
    super.initState();
    _angle = widget.startingAngle;
    _ticker = createTicker((elapsed) {
      final seconds = elapsed.inMilliseconds / 1000;
      final newAngle = (widget.startingAngle + seconds * widget.rotationSpeed) % 360;
      setState(() => _angle = newAngle);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(colorFilter: _hueRotation(_angle), child: widget.image);
  }
}

/// Image that applies a hue rotation based on the nearest [RotatingHue].
/// The shared angle comes from [RotatingHue.of]; [startingAngle]
/// can be used to offset this image's phase.
class RotatingHueImage extends StatelessWidget{
  final Image image;
  final double startingAngle;

  const RotatingHueImage({
    required this.image,
    this.startingAngle = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final angle = RotatingHue.of(context) ?? 0 + startingAngle;
    return ColorFiltered(colorFilter: _hueRotation(angle), child: image);
  }
}

/// Drives a shared hue-rotation animation for its subtree.
/// Wrap any widget tree that contains [RotatingHueImage] widgets.
///
/// Descendants can read the current angle in degrees via [RotatingHue.of].
class RotatingHue extends StatefulWidget {
  final Widget child;
  final double rotationSpeed;
  const RotatingHue({
    required this.child,
    this.rotationSpeed = 10,
    super.key
  });

  /// Returns the current shared hue angle in degrees from the nearest
  /// [RotatingHue] above [context], or null if none is found.
  static double? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RotatingHueScope>()?.angle;

  @override
  State<RotatingHue> createState() => _RotatingHueState();
}

class _RotatingHueState extends State<RotatingHue>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late double _angle;

  @override
  void initState() {
    super.initState();
    _angle = 0;
    _ticker = createTicker((elapsed) {
      final seconds = elapsed.inMilliseconds / 1000;
      setState(() => _angle = (seconds * widget.rotationSpeed) % 360);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RotatingHueScope(
      angle: _angle,
      child: widget.child,
    );
  }
}

class _RotatingHueScope extends InheritedWidget {
  final double angle;
  const _RotatingHueScope({
    required this.angle,
    required super.child,
  });

  @override
  bool updateShouldNotify(
    _RotatingHueScope oldWidget) =>
      angle != oldWidget.angle;
}

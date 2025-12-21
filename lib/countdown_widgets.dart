import 'package:flutter/material.dart';
import 'dart:math';
import 'countdown_logic.dart';


class CountdownRing extends StatelessWidget {
  final double value;
  final double rotationAngle;
  final double size;
  final double strokeWidth;
  final Color fgColor;
  final Color bgColor;
  const CountdownRing({
    required this.value,
    required this.rotationAngle,
    required this.size,
    required this.strokeWidth,
    required this.fgColor,
    required this.bgColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Transform.rotate(
        angle: rotationAngle,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: fgColor,
          backgroundColor: bgColor,
        ),
      ),
    );
  }
}

class CountdownLabel extends StatelessWidget {
  final int remainingSeconds;
  final Color color;
  final double fontSize;

  const CountdownLabel({
    required this.remainingSeconds,
    required this.color,
    required this.fontSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      0 != remainingSeconds
      ? remainingSeconds.toString().padLeft(2, '0')
      : "0",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      )
    );
  }
}

class CountdownTimer extends StatelessWidget {
  final CountdownStatus status;
  final double baseSize;
  const CountdownTimer({
    required this.status,
    required this.baseSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final double rotationAngle = -status.remainingSeconds / 30 * pi;
    final double value = status.isRunning
      ? status.withinSecondMs / 1000
      : 1;

    final bool danger = status.isInDangerZone;
    final bool filling = status.isRunning && status.remainingSeconds % 2 == 0;

    final Color bgRingTrack;
    final Color bgRingFill;
    final Color fgRingTrack;
    final Color fgRingFill;
    switch ((danger, filling)) {
      case (true, true) : {
        bgRingTrack = cs.surface;
        bgRingFill = cs.errorContainer;
        fgRingTrack = cs.surface;
        fgRingFill = cs.onErrorContainer;
      }
      case (true, false) : {
        bgRingTrack = cs.errorContainer;
        bgRingFill = cs.surface;
        fgRingTrack = cs.onErrorContainer;
        fgRingFill = cs.surface;
      }
      case (false, true) : {
        bgRingTrack = cs.surface;
        bgRingFill = cs.secondaryContainer;
        fgRingTrack = cs.surface;
        fgRingFill = cs.onSecondaryContainer;
      }
      case (false, false) : {
        bgRingTrack = cs.secondaryContainer;
        bgRingFill = cs.surface;
        fgRingTrack = cs.onSecondaryContainer;
        fgRingFill = cs.surface;
      }
    }
    Color labelColor = status.isInDangerZone
      ? cs.onSecondaryContainer
      : cs.onErrorContainer;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // bg ring: sector with container color
        CountdownRing(
          value: value,
          rotationAngle: rotationAngle,
          size: baseSize*1.5,
          strokeWidth: baseSize*1.5,
          fgColor: bgRingTrack,
          bgColor: bgRingFill,
        ),
        // fg ring: arc with onContainer color
        CountdownRing(
          value: value,
          rotationAngle: rotationAngle,
          size: baseSize*3,
          strokeWidth: baseSize/4,
          fgColor: fgRingTrack,
          bgColor: fgRingFill,
        ),
        CountdownLabel(
          remainingSeconds: status.remainingSeconds,
          color: labelColor,
          fontSize: baseSize,
        ),
      ],
    );
  }
}

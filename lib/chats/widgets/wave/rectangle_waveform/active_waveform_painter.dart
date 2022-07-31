// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';

import '../core/waveform_painters_ab.dart';
import '../utils/waveform_alignment.dart';
// import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
// import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
// import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/rectangle_waveform.dart';

///ActiveWaveformPainter for the [RectangleWaveform]
class RectangleActiveWaveformPainter extends ActiveWaveformPainter {
  // ignore: public_member_api_docs
  RectangleActiveWaveformPainter({
    required Color color,
    required List<double> activeSamples,
    required WaveformAlignment waveformAlignment,
    required double sampleWidth,
    required Color borderColor,
    required double borderWidth,
    Gradient? gradient,
  }) : super(
          color: color,
          gradient: gradient,
          activeSamples: activeSamples,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
          borderColor: borderColor,
          borderWidth: borderWidth,
          style: PaintingStyle.fill,
        );

  @override
  void paint(Canvas canvas, Size size) {
    final activeTrackPaint = Paint()
      ..style = style
      ..color = color
      ..strokeCap = StrokeCap.round
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = borderWidth;

    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);
    //print('samples length for active: ${activeSamples.length}');

    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];

      //print('x: $x, y: $y');

      // canvas..drawLine(
      //   Offset(i.toDouble() * 5, max(y * 0.75, y * 0.75)),
      //   Offset(i.toDouble() * 5, min(y / (i.toDouble() * 5), y / (i.toDouble() * 5))),
      //   activeTrackPaint,
      // )..drawLine(
      //   Offset(i.toDouble() * 5, max(y * 0.75, y * 0.75)),
      //   Offset(i.toDouble() * 5, min(y / (i.toDouble() * 5), y / (i.toDouble() * 5))),
      //   borderPaint,
      // );

      canvas
        ..drawLine(
          Offset(i.toDouble() * 5, max(y * 0.75, y * 0.75)),
          Offset(
              i.toDouble() * 5,
              y.abs() == 0
                  ? 0
                  : min(y / (i.toDouble() * 30), y / (i.toDouble() * 30))),
          activeTrackPaint,
        )
        ..drawLine(
          Offset(i.toDouble() * 5, max(y * 0.75, y * 0.75)),
          Offset(
              i.toDouble() * 5,
              y.abs() == 0
                  ? 0
                  : min(y / (i.toDouble() * 30), y / (i.toDouble() * 30))),
          borderPaint,
        );
    }
  }
}

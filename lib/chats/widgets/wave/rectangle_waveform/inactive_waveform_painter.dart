// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';

import '../core/waveform_painters_ab.dart';
import '../utils/waveform_alignment.dart';
// import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
// import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
// import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/rectangle_waveform.dart';

///InActiveWaveformPainter for the [RectangleWaveform].
class RectangleInActiveWaveformPainter extends InActiveWaveformPainter {
  // ignore: public_member_api_docs
  RectangleInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
    required WaveformAlignment waveformAlignment,
    required double sampleWidth,
    required Color borderColor,
    required double borderWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
          borderColor: borderColor,
          borderWidth: borderWidth,
          style: PaintingStyle.fill,
        );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
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
    //print('samples length for inactive: ${samples.length}');

    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      var y = samples[i];

      //print('x: $x, y: $y');
      //print('Width of the the whole canvas: ${size.width}, height: ${size.height}');
      // canvas..drawLine(
      //   Offset(i.toDouble() * 5, max(y * 0.75, y * 0.75)),
      //   Offset(i.toDouble() * 5, min(y / (i.toDouble() * 5), y / (i.toDouble() * 5))),
      //   paint,
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
          paint,
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

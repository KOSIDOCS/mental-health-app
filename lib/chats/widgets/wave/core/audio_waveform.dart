import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../utils/check_samples_equality.dart';
import '../utils/waveform_alignment.dart';
// import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
// import 'package:flutter_audio_waveforms/src/util/check_samples_equality.dart';
// import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';

/// [AudioWaveform] is a custom StatefulWidget that other Waveform classes
/// extend to.
///
/// This class handles the common functionality, properties and provides the
/// most common waveform details to the subclasses. This details then can be
/// used by the [WaveformPainter] to paint the waveform.
///
/// Anything that can be shared and used across all waveforms should
/// be handled by this class.
///
abstract class AudioWaveform extends StatefulWidget {
  /// Constructor for [AudioWaveform]
  AudioWaveform({
    Key? key,
    required this.samples,
    required this.height,
    required this.width,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.showActiveWaveform,
    this.absolute = false,
    this.invert = false,
  })  : assert(
          elapsedDuration.inMilliseconds <= maxDuration.inMilliseconds,
          'elapsedDuration must be less than or equal to maxDuration',
        ),
        assert(
          maxDuration.inMilliseconds > 0,
          'maxDuration must be greater than 0',
        ),
        waveformAlignment = absolute
            ? invert
                ? WaveformAlignment.top
                : WaveformAlignment.bottom
            : WaveformAlignment.center,
        super(key: key);

  /// Audio samples raw input.
  /// This raw samples are processed before being used to paint the waveform.
  final List<double> samples;

  /// Height of the canvas on which the waveform will be drawn.
  final double height;

  /// Width of the canvas on which the waveform will be drawn.
  final double width;

  /// Maximum duration of the audio.
  final Duration maxDuration;

  /// Elapsed duration of the audio.
  final Duration elapsedDuration;

  /// Makes the waveform absolute.
  /// Draws the waveform along the positive y-axis.
  /// Samples are processed such that we end up with positive sample values.
  final bool absolute;

  /// Inverts/Flips the waveform along x-axis.
  /// Samples are processed such that we end up with samples having opposite
  /// sign.
  final bool invert;

  /// Whether to show the active waveform or not.
  final bool showActiveWaveform;

  /// Alignment of the waveform in the canvas.
  @protected
  final WaveformAlignment waveformAlignment;

  @override
  AudioWaveformState<AudioWaveform> createState();
}

/// State of the [AudioWaveform]
abstract class AudioWaveformState<T extends AudioWaveform> extends State<T> {
  /// Samples after processing.
  /// This are used to paint the waveform.
  late List<double> _processedSamples;

  late List<double> _stretchedSamples;

  ///Getter for processed samples.
  List<double> get processedSamples => _processedSamples;

  late double _sampleWidth;

  ///Getter for sample width.
  double get sampleWidth => _sampleWidth;

  ///Method for subsclass to update the processed samples
  @protected
  // ignore: use_setters_to_change_properties
  void updateProcessedSamples(List<double> updatedSamples) {
    _processedSamples = updatedSamples;
  }

  /// Active index of the sample in the raw samples.
  ///
  /// Used to obtain the [activeSamples] for the audio as the
  /// audio progresses.
  /// This is calculated based on the [elapsedDuration], [maxDuration] and the
  /// raw samples.
  ///
  /// final elapsedTimeRatio = elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;
  /// _activeIndex = (widget.samples.length * elapsedTimeRatio).round();
  late int _activeIndex;

  /// Active samples that are used to draw the ActiveWaveform.
  /// This are calculated using [_activeIndex] and are subList of the
  /// [_processedSamples] at any given time.
  late List<double> _activeSamples;

  ///Getter for active samples.
  List<double> get activeSamples => _activeSamples;

  ///Getter for maxDuration
  Duration get maxDuration => widget.maxDuration;

  ///getter for elapsedDuration
  Duration get elapsedDuration => widget.elapsedDuration;

  ///Whether to show active waveform or not
  bool get showActiveWaveform => widget.showActiveWaveform;

  ///Whether to invert/flip waveform or not
  bool get invert => widget.absolute ? !widget.invert : widget.invert;

  ///Whether to show absolute waveform or not
  bool get absolute => widget.absolute;

  ///Getter for waveformAlignment.
  WaveformAlignment get waveformAlignment => widget.waveformAlignment;

  /// Raw samples are processed before used following some
  /// techniques. This is to have consistent samples that can be used to draw
  /// the waveform properly.
  @protected
  void processSamples() {
    final rawSamples = widget.samples;
    int threshold = (widget.width/4.9).floor();

    _stretchedSamples = _largestTriangleThreeBuckets(rawSamples, threshold);

    _processedSamples = _stretchedSamples
        .map((e) => absolute ? e.abs() * widget.height : e * widget.height)
        .toList();

    final maxNum =
        _processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));

    if (maxNum > 0) {
      final multiplier = math.pow(maxNum, -1).toDouble();
      final finalHeight = absolute ? widget.height : widget.height / 2;
      final finalMultiplier = multiplier * finalHeight;

      _processedSamples = _processedSamples
          .map(
            (e) => invert ? -e * finalMultiplier : e * finalMultiplier,
          )
          .toList();
    }
  }

  List<double> _largestTriangleThreeBuckets(List<double> data, threshold) {
    // data is linear array [90,87,97...]
    var data_length = data.length;
    if (threshold >= data_length || threshold == 0) {
      return data; // Nothing to do
    }

    List<double> sampled = [];
    //var sampled_index = 0;

    // Bucket size. Leave room for start and end data points
    var every = (data_length - 2) / (threshold - 2);

    var a = 0; // Initially a is the first point in the triangle
    var max_area_point;
    var max_area;
    var area;
    var next_a;

    // sampled[ sampled_index ] = data[ a ]; // Always add the first point

    sampled.add(data[a]);

    for (var i = 0; i < threshold - 2; i++) {
      // Calculate point average for next bucket (containing c)
      var avg_x = 0;
      var avg_y = 0;
      var avg_range_start = (((i + 1) * every) + 1).floor();
      var avg_range_end = (((i + 2) * every) + 1).floor();
      avg_range_end = avg_range_end < data_length ? avg_range_end : data_length;

      var avg_range_length = avg_range_end - avg_range_start;

      for (; avg_range_start < avg_range_end; avg_range_start++) {
        avg_x += avg_range_start;
        avg_y += data[avg_range_start].toInt() *
            1; // * 1 enforces Number (value may be Date)
      }

      avg_x ~/= avg_range_length;
      avg_y ~/= avg_range_length;

      // Get the range for this bucket
      var range_offs = (((i + 0) * every) + 1).floor(),
          range_to = (((i + 1) * every) + 1).floor();

      // Point a
      var point_a_x = a * 1, // enforce Number (value may be Date)
          point_a_y = data[a] * 1;

      max_area = area = -1;

      for (; range_offs < range_to; range_offs++) {
        // Calculate triangle area over three buckets
        area = (((point_a_x - avg_x) * (data[range_offs] - point_a_y) -
                    (point_a_x - range_offs) * (avg_y - point_a_y)) *
                0.5)
            .abs();
        if (area > max_area) {
          max_area = area;
          max_area_point = data[range_offs];
          next_a = range_offs; // Next a is this b
        }
      }

      //sampled[ sampled_index++ ] = max_area_point; // Pick this point from the bucket
      sampled.add(max_area_point);
      a = next_a; // This a is the next a (chosen b)
    }

    //sampled[ sampled_index++ ] = data[ data_length - 1 ]; // Always add last
    sampled.add(data[data_length - 1]);
    return sampled;
  }

  /// Calculates the width that each sample would take.
  /// This is later used in the Painters to calculate the Offset along x-axis
  /// from the start for any sample while painting.
  void _calculateSampleWidth() {
    _sampleWidth = widget.width / (_processedSamples.length);
  }

  /// Updates the [_activeIndex] whenever the duration changes.
  @protected
  void _updateActiveIndex() {
    // if (activeIndex != null) {
    //   _activeIndex = activeIndex;

    //   return;
    // }
    final elapsedTimeRatio =
        elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

    // _activeIndex = (widget.samples.length * elapsedTimeRatio).round();
    _activeIndex = (_stretchedSamples.length * elapsedTimeRatio).round();
    //print('All the actives samples here: $_activeSamples and the active index is $_activeIndex and the elapsed time ratio is $elapsedTimeRatio');
  }

  /// Updates [_activeSamples] based on the [_activeIndex].
  @protected
  void _updateActiveSamples() {
    _activeSamples = _processedSamples.sublist(0, _activeIndex);
  }

  /// This is to calculate both the [_processedSamples] and [_activeSamples] when the [elapsedDuration]
  /// and [totalDuration] are passed in.
  void _mainSetup() {
    final rawSamples = widget.samples;

    int threshold = (widget.width/4.9).floor();

    _stretchedSamples = _largestTriangleThreeBuckets(rawSamples, threshold);

    _processedSamples = _stretchedSamples
        .map((e) => absolute ? e.abs() * widget.height : e * widget.height)
        .toList();

    final maxNum = _processedSamples.length > 0
        ? _processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()))
        : 0;

    if (maxNum > 0) {
      final multiplier = math.pow(maxNum, -1).toDouble();
      final finalHeight = absolute ? widget.height : widget.height / 2;
      final finalMultiplier = multiplier * finalHeight;

      _processedSamples = _processedSamples
          .map(
            (e) => invert ? -e * finalMultiplier : e * finalMultiplier,
          )
          .toList();
    }

    _sampleWidth = widget.width / (_processedSamples.length);

    final elapsedTimeRatio =
        elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

    // _activeIndex = (widget.samples.length * elapsedTimeRatio).round();
    _activeIndex = (_stretchedSamples.length * elapsedTimeRatio).round();

    _activeSamples = _processedSamples.sublist(0, _activeIndex);
    //print('All the actives samples here: $_activeSamples and the active index is $_activeIndex and the elapsed time ratio is $elapsedTimeRatio, and length is ${_stretchedSamples.length}, width is ${widget.width}, and width divided by 3 is ${threshold}, and bucket ${_largestTriangleThreeBuckets(rawSamples, threshold).length}');
  }

  @override
  void initState() {
    super.initState();

    _mainSetup();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!checkforSamplesEquality(widget.samples, oldWidget.samples) &&
        widget.samples.isNotEmpty) {
      processSamples();
      _calculateSampleWidth();
      _updateActiveIndex();
      _updateActiveSamples();
    }
    if (widget.showActiveWaveform) {
      if (widget.elapsedDuration != oldWidget.elapsedDuration) {
        _updateActiveIndex();
        _updateActiveSamples();
      }
    }
    if (widget.height != oldWidget.height || widget.width != oldWidget.width) {
      processSamples();
      _calculateSampleWidth();
      _updateActiveSamples();
    }
    if (widget.absolute != oldWidget.absolute) {
      processSamples();
      _updateActiveSamples();
    }
    if (widget.invert != oldWidget.invert) {
      processSamples();
      _updateActiveSamples();
    }
  }
}

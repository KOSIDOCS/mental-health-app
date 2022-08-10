import 'package:flutter/material.dart';

/// This utility generic functions is used to align widgets.

T centered<T>() {
  switch (T) {
    case CrossAxisAlignment:
      return CrossAxisAlignment.center as T;
    case MainAxisAlignment:
     return MainAxisAlignment.center as T;
    case TextAlign:
      return TextAlign.center as T;
    case Alignment:
      return Alignment.center as T;       
    default:
    throw UnsupportedError('$T is not supported');
  }
}

T leftAligned<T>() {
  switch (T) {
    case CrossAxisAlignment:
      return CrossAxisAlignment.start as T;
    case MainAxisAlignment:
     return MainAxisAlignment.start as T;
    case TextAlign:
      return TextAlign.start as T;
    case Alignment:
      return Alignment.topLeft as T;       
    default:
    throw UnsupportedError('$T is not supported');
  }
}
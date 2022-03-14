import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

final DynamicLibrary nativeOpenCVLib = Platform.isAndroid
    ? DynamicLibrary.open('libnative_opencv.so')
    : DynamicLibrary.process();

typedef ConvertToASCIIStringC = Pointer<Uint8> Function(
  Pointer<Uint8> bytes,
  Int32 width,
  Int32 height,
  Int32 newWidth,
  Int32 newHeight,
  Pointer<Utf8> density,
  Bool isYUV,
  Int32 flipCode,
  Pointer<Int32> outLength,
);

typedef ConvertToASCIIStringDart = Pointer<Uint8> Function(
  Pointer<Uint8> bytes,
  int width,
  int height,
  int newWidth,
  int newHeight,
  Pointer<Utf8> density,
  bool isYUV,
  int flipCode,
  Pointer<Int32> outLength,
);

final _convertToAsciiString = nativeOpenCVLib
    .lookup<NativeFunction<ConvertToASCIIStringC>>('convert_to_ascii_string')
    .asFunction<ConvertToASCIIStringDart>();

enum FlipMode { none, horizontal, vertical, both }

class NativeOpencv {
  String convertToAsciiString(
    Uint8List yBuffer,
    Uint8List? uBuffer,
    Uint8List? vBuffer,
    int width,
    int height,
    int newWidth,
    int newHeight,
    String density,
    FlipMode flipMode,
  ) {
    final ySize = yBuffer.lengthInBytes;
    final uSize = uBuffer?.lengthInBytes ?? 0;
    final vSize = vBuffer?.lengthInBytes ?? 0;
    final totalSize = ySize + uSize + vSize;

    final imageBuffer = malloc.allocate<Uint8>(totalSize);
    final bytes = imageBuffer.asTypedList(totalSize);
    bytes.setAll(0, yBuffer);

    if (Platform.isAndroid) {
      bytes.setAll(ySize, vBuffer!);
      bytes.setAll(ySize + vSize, uBuffer!);
    }

    final outLength = malloc.allocate<Int32>(1);

    final asciiString = _convertToAsciiString(
      imageBuffer,
      width,
      height,
      newWidth,
      newHeight,
      density.toNativeUtf8(),
      Platform.isAndroid,
      flipMode.value,
      outLength,
    );

    final asciiStringBytes = asciiString.asTypedList(outLength.value);

    malloc.free(imageBuffer);
    malloc.free(outLength);

    return utf8.decode(asciiStringBytes, allowMalformed: true);
  }
}

extension FlipModeExtension on FlipMode {
  int get value {
    switch (this) {
      case FlipMode.none:
        return 999;
      case FlipMode.horizontal:
        return 0;
      case FlipMode.vertical:
        return 1;
      case FlipMode.both:
        return -1;
    }
  }
}

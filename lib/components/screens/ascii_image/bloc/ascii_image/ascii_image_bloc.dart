import 'dart:io';
import 'dart:typed_data';

import 'package:ascii_camera/ffi/native_opencv.dart';
import 'package:ascii_camera/utils/nullable.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ascii_image_event.dart';

part 'ascii_image_state.dart';

extension BlocExtension on BuildContext {
  ASCIIImageBloc get asciiImageBloc => read<ASCIIImageBloc>();
}

const List<Size> _imageResolutionPresets = [
  Size(24, 32),
  Size(48, 64),
  Size(96, 128),
];

class ASCIIImageBloc extends Bloc<ASCIIImageEvent, ASCIIImageState> {
  ASCIIImageBloc() : super(const ASCIIImageState.initial()) {
    on<Initialize>(_onInitialize);
    on<ChangeASCIIString>(_onChangeASCIIString);
    on<ChangeCamera>(_onChangeCamera);

    _initialize();
  }

  static const String _density = " .:-=+*#%@";

  final NativeOpencv _nativeOpencv = NativeOpencv();

  final List<CameraDescription> _cameras = [];

  late CameraDescription _camera;

  CameraController? _cameraController;
  Size _imageResolutionPreset = _imageResolutionPresets[0];
  bool _isImageProcessing = false;

  void changeImageResolutionPreset() {
    int index = _imageResolutionPresets.indexOf(_imageResolutionPreset);
    index = (index + 1 == _imageResolutionPresets.length) ? 0 : index + 1;
    _imageResolutionPreset = _imageResolutionPresets[index];
  }

  void toggleImageProcessing() {
    _isImageProcessing = !_isImageProcessing;
  }

  void openCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    add(const ChangeCamera(cameraController: null));
    await _onNewCameraSelected(_camera = _cameras[0]);
    add(ChangeCamera(cameraController: _cameraController));
  }

  void closeCamera({updateState = true}) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_cameraController!.value.isStreamingImages) {
      _cameraController!.stopImageStream();
    }

    if (updateState) {
      add(const ChangeCamera(cameraController: null));
    }
  }

  void swapCamera() async {
    if (_cameras.length > 1) {
      int index = _cameras.indexOf(_camera);
      index = index == 0 ? 1 : 0;

      add(const ChangeCamera(cameraController: null));
      await _onNewCameraSelected(_camera = _cameras[index]);
      add(ChangeCamera(cameraController: _cameraController));
    }
  }

  void dispose() {
    _cameraController?.dispose();
  }

  void _initialize() async {
    _cameras.addAll(await availableCameras());

    if (_cameras.isEmpty) {
      return;
    }

    add(const ChangeCamera(cameraController: null));
    await _onNewCameraSelected(_camera = _cameras[0]);
    add(Initialize(cameraController: _cameraController));
  }

  void _onInitialize(
    Initialize event,
    Emitter<ASCIIImageState> emit,
  ) async {
    emit(state.copyWith(
      cameraController: Nullable(event.cameraController),
      error: Nullable(null),
    ));
  }

  void _onChangeASCIIString(
    ChangeASCIIString event,
    Emitter<ASCIIImageState> emit,
  ) async {
    emit(state.copyWith(
      asciiString: event.asciiString,
      error: Nullable(null),
    ));
  }

  Future<void> _onNewCameraSelected(
    CameraDescription cameraDescription,
  ) async {
    final previousCameraController = _cameraController;

    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    if (previousCameraController != null) {
      if (previousCameraController.value.isStreamingImages) {
        await previousCameraController.stopImageStream();
      }
      await previousCameraController.dispose();
    }

    try {
      await _cameraController!.initialize();

      _cameraController!.startImageStream((image) {
        if (_isImageProcessing) {
          final planes = image.planes;
          final yBuffer = planes[0].bytes;

          Uint8List? uBuffer;
          Uint8List? vBuffer;

          if (Platform.isAndroid) {
            uBuffer = planes[1].bytes;
            vBuffer = planes[2].bytes;
          }

          FlipMode flipMode = FlipMode.none;
          if (_cameras.indexOf(_camera) == 1) {
            flipMode = FlipMode.vertical;
          }

          final asciiString = _nativeOpencv.convertToAsciiString(
            yBuffer,
            uBuffer,
            vBuffer,
            image.width,
            image.height,
            _imageResolutionPreset.width.toInt(),
            _imageResolutionPreset.height.toInt(),
            _density,
            flipMode,
          );

          if (asciiString.isNotEmpty) {
            add(ChangeASCIIString(asciiString: asciiString));
          }
        }
      });
    } on CameraException catch (e) {
      _logError(e.code, e.description);
    }
  }

  void _logError(String code, String? message) {
    if (message != null) {
      debugPrint('Error: $code\nError Message: $message');
    } else {
      debugPrint('Error: $code');
    }
  }

  void _onChangeCamera(
    ChangeCamera event,
    Emitter<ASCIIImageState> emit,
  ) async {
    emit(state.copyWith(
      cameraController: Nullable(event.cameraController),
      error: Nullable(null),
    ));
  }
}

part of 'ascii_image_bloc.dart';

enum CameraStatus {
  undefined,
  initialized,
  notExists,
}

class ASCIIImageState extends Equatable {
  const ASCIIImageState._({
    this.cameraController,
    required this.asciiString,
    this.error,
  });

  const ASCIIImageState.initial() : this._(asciiString: '');

  final CameraController? cameraController;
  final String asciiString;
  final String? error;

  ASCIIImageState copyWith({
    Nullable<CameraController>? cameraController,
    String? asciiString,
    Nullable<String>? error,
  }) =>
      ASCIIImageState._(
        cameraController: cameraController != null
            ? cameraController.value
            : this.cameraController,
        asciiString: asciiString ?? this.asciiString,
        error: error != null ? error.value : this.error,
      );

  @override
  List<Object?> get props => [
        cameraController,
        asciiString,
        error,
      ];
}

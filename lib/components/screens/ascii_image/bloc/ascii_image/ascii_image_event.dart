part of 'ascii_image_bloc.dart';

abstract class ASCIIImageEvent extends Equatable {
  const ASCIIImageEvent();

  @override
  List<Object?> get props => [];
}

class Initialize extends ASCIIImageEvent {
  const Initialize({this.cameraController});

  final CameraController? cameraController;

  @override
  List<Object?> get props => [cameraController];
}

class ChangeASCIIString extends ASCIIImageEvent {
  const ChangeASCIIString({required this.asciiString});

  final String asciiString;

  @override
  List<Object> get props => [asciiString];
}

class ChangeCamera extends ASCIIImageEvent {
  const ChangeCamera({this.cameraController});

  final CameraController? cameraController;

  @override
  List<Object?> get props => [cameraController];
}

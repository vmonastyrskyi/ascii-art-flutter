part of 'options_bloc.dart';

abstract class OptionsEvent extends Equatable {
  const OptionsEvent();

  @override
  List<Object> get props => [];
}

class ToggleCameraPreview extends OptionsEvent {
  const ToggleCameraPreview();
}

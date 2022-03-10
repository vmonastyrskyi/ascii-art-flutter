part of 'options_bloc.dart';

abstract class OptionsEvent extends Equatable {
  const OptionsEvent();

  @override
  List<Object> get props => [];
}

class ToggleOptionButtons extends OptionsEvent {
  const ToggleOptionButtons();
}

class ToggleCameraPreview extends OptionsEvent {
  const ToggleCameraPreview();
}

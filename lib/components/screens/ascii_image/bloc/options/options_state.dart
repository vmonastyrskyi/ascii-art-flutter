part of 'options_bloc.dart';

class OptionsState extends Equatable {
  const OptionsState._({
    required this.showOptionButtons,
    required this.showCameraPreview,
  });

  const OptionsState.initial()
      : this._(
          showOptionButtons: true,
          showCameraPreview: true,
        );

  final bool showOptionButtons;
  final bool showCameraPreview;

  OptionsState copyWith({
    bool? showOptionButtons,
    bool? showCameraPreview,
  }) =>
      OptionsState._(
        showOptionButtons: showOptionButtons ?? this.showOptionButtons,
        showCameraPreview: showCameraPreview ?? this.showCameraPreview,
      );

  @override
  List<Object> get props => [
        showOptionButtons,
        showCameraPreview,
      ];
}

part of 'options_bloc.dart';

class OptionsState extends Equatable {
  const OptionsState._({required this.cameraPreview});

  const OptionsState.initial()
      : this._(
          cameraPreview: true,
        );

  final bool cameraPreview;

  OptionsState copyWith({
    bool? showOptions,
  }) =>
      OptionsState._(
        cameraPreview: showOptions ?? this.cameraPreview,
      );

  @override
  List<Object> get props => [cameraPreview];
}

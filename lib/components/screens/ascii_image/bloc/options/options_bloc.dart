import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'options_event.dart';
part 'options_state.dart';

extension BlocExtension on BuildContext {
  OptionsBloc get optionsBloc => read<OptionsBloc>();
}

class OptionsBloc extends Bloc<OptionsEvent, OptionsState> {
  OptionsBloc() : super(const OptionsState.initial()) {
    on<ToggleOptionButtons>(_onToggleOptionButtons);
    on<ToggleCameraPreview>(_onToggleCameraPreview);
  }

  void toggleOptionButtons() {
    add(const ToggleOptionButtons());
  }

  void toggleCameraPreview() {
    add(const ToggleCameraPreview());
  }

  void _onToggleOptionButtons(
    ToggleOptionButtons event,
    Emitter<OptionsState> emit,
  ) async {
    emit(state.copyWith(showOptionButtons: !state.showOptionButtons));
  }

  void _onToggleCameraPreview(
    ToggleCameraPreview event,
    Emitter<OptionsState> emit,
  ) async {
    emit(state.copyWith(showCameraPreview: !state.showCameraPreview));
  }
}

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
    on<ToggleCameraPreview>(_onToggleCameraPreview);
  }

  void _onToggleCameraPreview(
    ToggleCameraPreview event,
    Emitter<OptionsState> emit,
  ) async {
    emit(state.copyWith(showOptions: !state.cameraPreview));
  }

  void toggleCameraPreview() {
    add(const ToggleCameraPreview());
  }
}

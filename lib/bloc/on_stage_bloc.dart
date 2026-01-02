import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songquest/bloc/on_stage_event.dart';
import 'package:songquest/bloc/on_stage_state.dart';

class OnStageBloc extends Bloc<OnStageEvent, OnStageState> {
  OnStageBloc() : super(OnStageInitial()) {
    on<OnStageTabChangedEvent>((event, emit) {
      emit(OnStageTabChanged(event.tabIndex));
    });
  }
}

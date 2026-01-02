abstract class OnStageState {}

class OnStageInitial extends OnStageState {}

class OnStageTabChanged extends OnStageState {
  final int tabIndex;

  OnStageTabChanged(this.tabIndex);
}

abstract class OnStageEvent {}

class OnStageTabChangedEvent extends OnStageEvent {
  final int tabIndex;

  OnStageTabChangedEvent(this.tabIndex);
}

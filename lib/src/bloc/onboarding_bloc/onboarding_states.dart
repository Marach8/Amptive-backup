abstract class AmptiveOnboardingState {}

class CurrentOnboardingPageViewIndexState extends AmptiveOnboardingState {
  CurrentOnboardingPageViewIndexState({required this.currentPageIndex});
  int currentPageIndex;
}

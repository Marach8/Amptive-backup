abstract class AmptiveOnboardingEvents {}

class SwipeToAnotherPageOnboardingEvent extends AmptiveOnboardingEvents {
  SwipeToAnotherPageOnboardingEvent({required this.indexOfDestinationPage});
  int indexOfDestinationPage;
}

class SkipButtonClickedOnboardingEvent extends AmptiveOnboardingEvents {}

class NextButtonClickedOnboardingEvent extends AmptiveOnboardingEvents {}

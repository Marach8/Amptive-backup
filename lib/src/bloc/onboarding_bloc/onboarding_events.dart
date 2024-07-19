abstract class AmptiveOnboardingEvents{}


class SwipeToAnotherPageOnboardingEvent extends AmptiveOnboardingEvents{
  int indexOfDestinationPage;
  SwipeToAnotherPageOnboardingEvent({required this.indexOfDestinationPage});
}

class SkipButtonClickedOnboardingEvent extends AmptiveOnboardingEvents{}

class NextButtonClickedOnboardingEvent extends AmptiveOnboardingEvents{}
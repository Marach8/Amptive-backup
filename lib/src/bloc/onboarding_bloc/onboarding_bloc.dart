import 'package:amptive/src/bloc/onboarding_bloc/onboarding_events.dart';
import 'package:amptive/src/bloc/onboarding_bloc/onboarding_states.dart';
import 'package:bloc/bloc.dart';

class AmptiveOnboardingBloc extends Bloc<AmptiveOnboardingEvents, AmptiveOnboardingState>{
  AmptiveOnboardingBloc(): super(CurrentOnboardingPageViewIndexState(currentPageIndex: 0)){
    

    on<SwipeToAnotherPageOnboardingEvent>((event, emit) {
      final currentPageIndex = event.indexOfDestinationPage;
      emit(CurrentOnboardingPageViewIndexState(currentPageIndex: currentPageIndex));
    });
  }
}
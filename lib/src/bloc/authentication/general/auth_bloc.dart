import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../../services/auth/auth_field_service.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AmptiveAuthBloc extends Bloc<AmptiveAuthEvent, AmptiveAuthState> {
  AmptiveAuthBloc() : super(InitialAuthState()) {
    on<EditDOBAuthEvent>(
        (EditDOBAuthEvent event, Emitter<AmptiveAuthState> emit) {
      AuthFieldService service = GetIt.I<AuthFieldService>();
      service.setDOB(event.selectedDate);

      emit(EditDOBAuthState(dob: service.dob));
    });

    on<HideOrShowPasswordAuthEvent>(
        (HideOrShowPasswordAuthEvent event, Emitter<AmptiveAuthState> emit) {
      emit(HideOrShowPasswordAuthState());
    });

    on<UsernameChangedEvent>(
        (UsernameChangedEvent event, Emitter<AmptiveAuthState> emit) async {
      emit(VerifyingUsernameState());
      await service.validateUsername(event.username);
      emit(UsernameVerifiedState());
    },
        transformer: (Stream<UsernameChangedEvent> events, mapper) =>
            events.debounceTime(Durations.extralong4).switchMap(mapper));

    on<NameChangedEvent>(
        (NameChangedEvent event, Emitter<AmptiveAuthState> emit) {
      emit(NameChangedState());
    });

    on<AddProfilePictureEvent>(
        (AddProfilePictureEvent event, Emitter<AmptiveAuthState> emit) {
      if (event.cancel) {
        service.clearProfilePicture();
        emit(ProfilePictureAddedState(image: null));
      } else {
        emit(AddProfilePictureState());
      }
    });

    on<ProfilePictureAddedEvent>(
        (ProfilePictureAddedEvent event, Emitter<AmptiveAuthState> emit) {
      service.setProfilePicture(event.image);
      emit(ProfilePictureAddedState(image: event.image.bytes));
    });

    on<AddPhoneNumberEvent>(
        (AddPhoneNumberEvent event, Emitter<AmptiveAuthState> emit) {
      service.validatePhoneNumber(event.value);
      emit(AddPhoneNumberState(isPhoneValid: service.isPhoneValid));
    });

    on<PickCountryCodeEvent>(
        (PickCountryCodeEvent event, Emitter<AmptiveAuthState> emit) {
      service.setCountry(event.country);
      emit(PickCountryCodeState(selectedCountry: service.country));
    });

    on<OpenCountryBottomSheetEvent>(
        (OpenCountryBottomSheetEvent event, Emitter<AmptiveAuthState> emit) {
      emit(OpenCountryBottomSheetState(selectedCountry: service.country));
    });
  }
  final AuthFieldService service = GetIt.I<AuthFieldService>();
}

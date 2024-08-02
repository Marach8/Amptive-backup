import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../../services/auth/auth_field_service.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AmptiveAuthBloc extends Bloc<AmptiveAuthEvent, AmptiveAuthState> {
  final service = GetIt.I<AuthFieldService>();

  AmptiveAuthBloc() : super(InitialAuthState()) {
    on<EditDOBAuthEvent>((event, emit) {
      var service = GetIt.I<AuthFieldService>();
      service.setDOB(event.selectedDate);

      emit(EditDOBAuthState(dob: service.dob));
    });

    on<HideOrShowPasswordAuthEvent>((event, emit) {
      emit(HideOrShowPasswordAuthState());
    });

    on<UsernameChangedEvent>((event, emit) async {
      emit(UsernameLoadingAuthState());
      await service.validateUsername(event.username);
      emit(UsernameValidatedAuthState());
    },
        transformer: (events, mapper) =>
            events.debounceTime(Durations.extralong4).switchMap(mapper));

    on<NameChangedEvent>((event, emit) {
      emit(NameChangedState());
    });

    on<AddProfilePictureEvent>((event, emit) {
      if (event.cancel) {
        service.clearProfilePicture();
        emit(ProfilePictureAddedState(image: null));
      } else {
        emit(AddProfilePictureState());
      }
    });

    on<ProfilePictureAddedEvent>((event, emit) {
      service.setProfilePicture(event.image);
      emit(ProfilePictureAddedState(image: event.image.bytes));
    });
  }
}

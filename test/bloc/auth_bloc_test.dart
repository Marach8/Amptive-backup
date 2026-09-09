import 'package:amptive/src/bloc/authentication/general/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/general/auth_events.dart';
import 'package:amptive/src/bloc/authentication/general/auth_states.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('AmptiveAuthBloc', () {
    setUp(() {
      if (!GetIt.I.isRegistered<AuthFieldService>()) {
        GetIt.I.registerSingleton<AuthFieldService>(AuthFieldService());
      }
    });

    blocTest<AmptiveAuthBloc, AmptiveAuthState>(
      'emits EditDOBAuthState with the selected date on EditDOBAuthEvent',
      build: () => AmptiveAuthBloc(),
      act: (AmptiveAuthBloc bloc) => bloc.add(
        EditDOBAuthEvent(selectedDate: DateTime(2000, 1, 2)),
      ),
      expect: <AmptiveAuthState>[
        (AmptiveAuthState state) =>
            state is EditDOBAuthState && state.dob == DateTime(2000, 1, 2),
      ],
    );

    blocTest<AmptiveAuthBloc, AmptiveAuthState>(
      'emits ProfilePictureAddedState(null image) on '
      'AddProfilePictureEvent(cancel: true)',
      build: () => AmptiveAuthBloc(),
      act: (AmptiveAuthBloc bloc) => bloc.add(const AddProfilePictureEvent(cancel: true)),
      expect: <AmptiveAuthState>[
        (AmptiveAuthState state) =>
            state is ProfilePictureAddedState && state.image == null,
      ],
    );

    blocTest<AmptiveAuthBloc, AmptiveAuthState>(
      'emits AddProfilePictureState on AddProfilePictureEvent(cancel: false)',
      build: () => AmptiveAuthBloc(),
      act: (AmptiveAuthBloc bloc) => bloc.add(const AddProfilePictureEvent(cancel: false)),
      expect: <AmptiveAuthState>[const AddProfilePictureState()],
    );

    blocTest<AmptiveAuthBloc, AmptiveAuthState>(
      'emits NameChangedState on NameChangedEvent',
      build: () => AmptiveAuthBloc(),
      act: (AmptiveAuthBloc bloc) => bloc.add(const NameChangedEvent()),
      expect: <AmptiveAuthState>[const NameChangedState()],
    );

    blocTest<AmptiveAuthBloc, AmptiveAuthState>(
      'emits HideOrShowPasswordAuthState on HideOrShowPasswordAuthEvent',
      build: () => AmptiveAuthBloc(),
      act: (AmptiveAuthBloc bloc) => bloc.add(const HideOrShowPasswordAuthEvent()),
      expect: <AmptiveAuthState>[const HideOrShowPasswordAuthState()],
    );
  });
}
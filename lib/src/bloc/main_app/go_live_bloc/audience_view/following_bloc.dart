import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveFollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  AmptiveFollowingBloc() : super(IsNotFollowingState()) {
    on<ShouldFollowEvent>((_, Emitter<FollowingState> emit) async {
      emit(FollowLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      emit(IsFollowingState());
    });

    on<ShouldUnFollowEvent>((_, Emitter<FollowingState> emit) async {
      emit(FollowLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      emit(IsNotFollowingState());
    });
  }
}

abstract class FollowingState {}

class IsFollowingState extends FollowingState {}

class FollowLoadingState extends FollowingState {}

class IsNotFollowingState extends FollowingState {}

abstract class FollowingEvent {}

class ShouldFollowEvent extends FollowingEvent {}

class ShouldUnFollowEvent extends FollowingEvent {}

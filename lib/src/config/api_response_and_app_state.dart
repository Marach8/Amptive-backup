import 'package:amptive/src/config/exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Silently drops emits that land after the cubit is closed — e.g. an
/// in-flight API call completing after the providing widget was disposed.
/// Without this, late responses crash with
/// "Bad state: Cannot emit new states after calling close".
mixin SafeEmit<State> on BlocBase<State> {
  @override
  void emit(State state) {
    if (isClosed) return;
    super.emit(state);
  }
}

//API RESPONSE
abstract class ApiResponse<T> {
  const ApiResponse();

  R when<R>({
    required R Function(Successful<T> _) successful,
    required R Function(Unsuccessful<T> _) unSuccessful,
  });
}

class Successful<T> extends ApiResponse<T> {
  Successful({this.data});
  final T? data;

  @override
  R when<R>({
    required R Function(Successful<T> _) successful,
    required R Function(Unsuccessful<T> _) unSuccessful,
  }) =>
      successful(this);
}

class Unsuccessful<T> extends ApiResponse<T> {
  Unsuccessful({required this.error});
  final ATException error;

  @override
  R when<R>({
    required R Function(Successful<T> _) successful,
    required R Function(Unsuccessful<T> _) unSuccessful,
  }) =>
      unSuccessful(this);
}

//APP STATES
sealed class ATAppState<T> {
  const ATAppState();
}

class InitialState<T> extends ATAppState<T> {
  const InitialState({this.initialData});
  final T? initialData;
}

class LoadingState<T> extends ATAppState<T> {
  const LoadingState({this.currentData});
  final T? currentData;
}

class FailureState<T> extends ATAppState<T> {
  const FailureState(
    this.message, {
    this.oldData,
    this.failureType = FailureType.apiCallFailure,
  });

  final String message;
  final T? oldData;
  final FailureType failureType;
}

enum FailureType { apiCallFailure, searchFailure, unknownFailure }

class SuccessState<T> extends ATAppState<T> {
  const SuccessState({this.newData, this.message});
  final T? newData;
  final String? message;
}
